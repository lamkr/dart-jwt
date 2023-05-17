import 'dart:convert';

import 'package:dart_jwt/exceptions/jwt_decode_exception.dart';
import 'package:dart_jwt/exceptions/throwable.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

import 'core_matchers.dart';

void main() {

  test('getSubject', () {
    DecodedJWT jwt = JWT.decode(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ');
    expect(jwt.subject, isNotEmpty);
    expect(jwt.subject, '1234567890');
    expect(jwt.issuer, isEmpty);
    expect(jwt.id, isEmpty);
  });

  // Exceptions

  test('should throw if the content is not properly encoded', () {
    try {
      JWT.decode(
          "eyJ0eXAiOiJKV1QiLCJhbGciO--corrupted.eyJ0ZXN0IjoxMjN9.sLtFC2rLAzN0-UJ13OLQX6ezNptAQzespaOGwCnpqk");
    }
    catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect(e.toString(), startsWith("The string '"));
      expect(e.toString(), endsWith("' doesn't have a valid JSON format."));
    }
  });

  test('Should throw if less than 3 parts', () {
    try {
      JWT.decode("two.parts");
    }
    catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(), "The token was expected to have 3 parts, but got 2.");
    }
  });

  test('should throw if more than 3 parts', () {
    try {
      JWT.decode("this.has.four.parts");
    }
    catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(), "The token was expected to have 3 parts, but got > 3.");
    }
  });

  test('Should throw if payload has invalid JSON format', () {
    const validJson = '{}';
    const invalidJson = '}{';
    try {
      _customJWT(validJson, invalidJson, 'signature');
    }
    catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(),
          "The string '$invalidJson' doesn't have a valid JSON format.");
    }
  });

  test('Should throw if header has invalid JSON format', () {
    const validJson = '{}';
    const invalidJson = '}{';
    try {
      _customJWT(invalidJson, validJson, 'signature');
    }
    catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(),
          "The string '$invalidJson' doesn't have a valid JSON format.");
    }
  });

  test('Should throw when header not valid base64', () {
    // NOTE:
    //   Different as Java, Dart's Base64 doesn't throws
    //   ArgumentError when jwt has plus character ('+'):
    //
    // const jwt = 'eyJhbGciOiJub25l+IiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.Ox-WRXRaGAuWt2KfPvWiGcCrPqZtbp_4OnQzZXaTfss';
    const jwt = 'eyJhbGciOiJub25l#IiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.Ox-WRXRaGAuWt2KfPvWiGcCrPqZtbp_4OnQzZXaTfss';
    try {
      JWT.decode(jwt);
    }
    on Throwable catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(e.cause, isA<FormatException>());
    }
  });

  test('Should throw when payload not valid base64', () {
    const jwt = "eyJhbGciOiJub25lIiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRo+MCJ9.Ox-WRXRaGAuWt2KfPvWiGcCrPqZtbp_4OnQzZXaTfss";
    try {
      JWT.decode(jwt);
    }
    on Throwable catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(e.cause, isA<FormatException>());
    }
  });

  // Parts

  test('Should throw when header length is not multiple of 4', () {
    const token = "eyJhbGciOiJIUzI1NiJ.e30g.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    try {
      JWT.decode(token);
    }
    on Throwable catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(e.cause, isA<FormatException>());
    }
  });

  test('Should throw when payload length is not multiple of 4', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    try {
      JWT.decode(token);
    }
    on Throwable catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(e.cause, isA<FormatException>());
    }
  });

  test('Should throw when signature length is not multiple of 4', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30g.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5ly";
    try {
      JWT.decode(token);
    }
    on Throwable catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(e.cause, isA<FormatException>());
    }
  });

  test('Should get string token', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    DecodedJWT jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.token, isNotEmpty);
    expect(jwt.token, token);
  });

  test('Should get header', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    DecodedJWT jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.header, isNotEmpty);
    expect(jwt.header, 'eyJhbGciOiJIUzI1NiJ9');
  });

  test('Should get payload', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    DecodedJWT jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.payload, isNotEmpty);
    expect(jwt.payload, 'e30');
  });

  test('Should get signature', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    DecodedJWT jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.signature, isNotEmpty);
    expect(jwt.signature, 'XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ');
  });

  // Standard Claims

  test('Should get issuer', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJKb2huIERvZSJ9.SgXosfRR_IwCgHq5lF3tlM-JHtpucWCRSaVuoHTbWbQ");
    expect(jwt, isValid);
    expect(jwt.issuer, "John Doe");
  });

  test('Should get subject', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJUb2szbnMifQ.RudAxkslimoOY3BLl2Ghny3BrUKu9I1ZrXzCZGDJtNs");
    expect(jwt, isValid);
    expect(jwt.subject, "Tok3ns");
  });

  test('Should get array audience', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOlsiSG9wZSIsIlRyYXZpcyIsIlNvbG9tb24iXX0.Tm4W8WnfPjlmHSmKFakdij0on2rWPETpoM7Sh0u6-S4");
    expect(jwt, isValid);
    expect(jwt.audience.length, 3);
    expect(jwt.audience, ["Hope", "Travis", "Solomon"]);
  });

  test('Should get string audience', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJKYWNrIFJleWVzIn0.a4I9BBhPt1OB1GW67g2P1bEHgi6zgOjGUL4LvhE9Dgc");
    expect(jwt, isValid);
    expect(jwt.audience.length, 1);
    expect(jwt.audience, ["Jack Reyes"]);
  });

  test('Should get expiration time', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0NzY3MjcwODZ9.L9dcPHEDQew2u9MkDCORFkfDGcSOsgoPqNY-LUMLEHg");
    expect(jwt, isValid);
    const ms = 1476727086 * 1000;
    expect(jwt.expiresAt, DateTime.fromMillisecondsSinceEpoch(ms));
  });

  test('Should get not before', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJuYmYiOjE0NzY3MjcwODZ9.tkpD3iCPQPVqjnjpDVp2bJMBAgpVCG9ZjlBuMitass0");
    expect(jwt, isValid);
    const ms = 1476727086 * 1000;
    expect(jwt.notBefore, DateTime.fromMillisecondsSinceEpoch(ms));
  });

  test('Should get issued at', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE0NzY3MjcwODZ9.KPjGoW665E8V5_27Jugab8qSTxLk2cgquhPCBfAP0_w");
    expect(jwt, isValid);
    const ms = 1476727086 * 1000;
    expect(jwt.issuedAt, DateTime.fromMillisecondsSinceEpoch(ms));
  });

  test('Should get Id', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxMjM0NTY3ODkwIn0.m3zgEfVUFOd-CvL3xG5BuOWLzb0zMQZCqiVNQQOPOvA");
    expect(jwt, isValid);
    expect(jwt.id, "1234567890");
  });

  test('Should get content type', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiIsImN0eSI6ImF3ZXNvbWUifQ.e30.AIm-pJDOaAyct9qKMlN-lQieqNDqc3d4erqUZc5SHAs");
    expect(jwt, isValid);
    expect(jwt.contentType, "awesome");
  });

  test('Should get type', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXUyJ9.e30.WdFmrzx8b9v_a-r6EHC2PTAaWywgm_8LiP8RBRhYwkI");
    expect(jwt, isValid);
    expect(jwt.type, "JWS");
  });

  test('Should get algorithm', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ");
    expect(jwt, isValid);
    expect(jwt.algorithm, "HS256");
  });

  // Private Claims

  test('Should get missing claim if claim does not exist', () {
    //const token = "eyJhbGciOiJIUzI1NiJ9.e30.K17vlwhE8FCMShdl1_65jEYqsQqBOVMPUU9IgG-QlTM";
    const p1 = 'eyJhbGciOiJIUzI1NiIsICJub3RFeGlzdGluZyI6IG51bGx9Cg==';
    const p2 = 'e30K';
    const p3 = 'K17vlwhE8FCMShdl1_65jEYqsQqBOVMPUU9IgG-QlTM';
    const token = '$p1.$p2.$p3';
    DecodedJWT jwt = JWT.decode(token);
    const notExisting = "notExisting";
    expect(jwt, isValid);
    final claim = jwt.claim(notExisting);
    expect(claim, isNotNull);
    expect(claim.isMissing(), isTrue);
    expect(claim.isNull(), isFalse);
  });

}

DecodedJWT _customJWT(String jsonHeader, String jsonPayload, String signature) {
  String header = base64.encode(jsonHeader.codeUnits);
  String body = base64.encode(jsonPayload.codeUnits);
  return JWT.decode('$header.$body.$signature');
}

