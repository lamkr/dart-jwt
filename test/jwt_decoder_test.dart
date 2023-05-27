import 'dart:convert';

import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

import 'lib/core_matchers.dart';

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

  test('Should get const token', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.token, isNotEmpty);
    expect(jwt.token, token);
  });

  test('Should get header', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.header, isNotEmpty);
    expect(jwt.header, 'eyJhbGciOiJIUzI1NiJ9');
  });

  test('Should get payload', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.payload, isNotEmpty);
    expect(jwt.payload, 'e30');
  });

  test('Should get signature', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.XmNK3GpH3Ys_7wsYBfq4C3M6goz71I7dTgUkuIa5lyQ";
    final jwt = JWT.decode(token);
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
    const token = "eyJhbGciOiJIUzI1NiJ9.e30.K17vlwhE8FCMShdl1_65jEYqsQqBOVMPUU9IgG-QlTM";
    final jwt = JWT.decode(token);
    const notExisting = "notExisting";
    expect(jwt, isValid);
    final claim = jwt.claim(notExisting);
    expect(claim, isValid);
    expect(claim.isMissing, isTrue);
    expect(claim.isNull, isFalse);
  });

  test('Should get null claim if claim exists but with null value', () {
    const p1 = 'eyJhbGciOiJIUzI1NiJ9';
    const p2 = 'eyJub3RFeGlzdGluZyI6bnVsbH0';
    const p3 = 'K17vlwhE8FCMShdl1_65jEYqsQqBOVMPUU9IgG-QlTM';
    const token = '$p1.$p2.$p3';
    final jwt = JWT.decode(token);
    const notExisting = "notExisting";
    expect(jwt, isValid);
    final claim = jwt.claim(notExisting);
    expect(claim, isValid);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isTrue);
  });

  test('Should get valid claim',() {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJvYmplY3QiOnsibmFtZSI6ImpvaG4ifX0.lrU1gZlOdlmTTeZwq0VI-pZx2iV46UWYd5-lCjy6-c4");
    expect(jwt, isValid);
    expect(jwt.claim("object"), isValid);
    expect(jwt.claim("object"), isA<Claim>());
  });

  test('Should not get null claim if claim is empty object', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiJ9.eyJvYmplY3QiOnt9fQ.d3nUeeL_69QsrHL0ZWij612LHEQxD8EZg1rNoY3a4aI");
    expect(jwt, isValid);
    expect(jwt.claim("object"), isValid);
    expect(jwt.claim("object").isNull, false);
  });

  test('Should get custom claim of type integer', () {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoxMjN9.XZAudnA7h3_Al5kJydzLjw6RzZC3Q6OvnLEYlhNW7HA";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.claim("name").asInt(), 123);
  });

  test('Should get custom claim of type double', () {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoyMy40NX0.7pyX2OmEGaU9q15T8bGFqRm-d3RVTYnqmZNZtxMKSlA";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.claim("name").asDouble(), 23.45);
  });

  test('Should get custom claim of type boolean',() {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjp0cnVlfQ.FwQ8VfsZNRqBa9PXMinSIQplfLU4-rkCLfIlTLg_MV0";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.claim("name").asBoolean(), true);
  });

  test('Should get custom claim of type DateTime', () {
    const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoxNDc4ODkxNTIxfQ.mhioumeok8fghQEhTKF3QtQAksSvZ_9wIhJmgZLhJ6c";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    final date = DateTime.fromMillisecondsSinceEpoch(1478891521000);
    expect(jwt.claim("name").asDateTime(), date);
  });

  test('Should get custom list claim of type String', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjpbInRleHQiLCIxMjMiLCJ0cnVlIl19.lxM8EcmK1uSZRAPd0HUhXGZJdauRmZmLjoeqz4J9yAA";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.claim("name").asList<String>(), containsAll(["text", "123", "true"]));
  });

  test('Should get custom array claim of type integer', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjpbMSwyLDNdfQ.UEuMKRQYrzKAiPpPLhIVawWkKWA1zj0_GderrWUIyFE";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    expect(jwt.claim("name").asList<int>(), containsAll([1,2,3]));
  });

  test('Should get custom map claim', () {
    const token = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjp7InN0cmluZyI6InZhbHVlIiwibnVtYmVyIjoxLCJib29sZWFuIjp0cnVlLCJlbXB0eSI6bnVsbH19.6xkCuYZnu4RA0xZSxlYSYAqzy9JDWsDtIWqSCUZlPt8";
    final jwt = JWT.decode(token);
    expect(jwt, isValid);
    Map<String, dynamic>? map = jwt.claim("name").asMap<dynamic>();
    expect(map, containsPair('string', 'value'));
    expect(map, containsPair('number', 1));
    expect(map, containsPair('boolean', true));
    expect(map, containsPair('empty', null));
  });

  test('Should get custom null claim', () {
    String token = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjpudWxsfQ.X4ALHe7uYqEcXWFBnwBUNRKwmwrtDEGZ2aynRYYUx8c";
    DecodedJWT jwt = JWT.decode(token);
    expect(jwt.claim("name").isNull, true);
  });

  test('Should get list claim', () {
    String token = "eyJhbGciOiJIUzI1NiJ9.eyJuYW1lIjpbbnVsbCwiaGVsbG8iXX0.SpcuQRBGdTV0ofHdxBSnhWEUsQi89noZUXin2Thwb70";
    DecodedJWT jwt = JWT.decode(token);
    expect(jwt.claim("name").asList<String?>(), containsAll([null, "hello"]));
  });

  test('Should get available claims', () {
    DecodedJWT jwt = JWT.decode("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjEyMzQ1Njc4OTAsImlhdCI6MTIzNDU2Nzg5MCwibmJmIjoxMjM0NTY3ODkwLCJqdGkiOiJodHRwczovL2p3dC5pby8iLCJhdWQiOiJodHRwczovL2RvbWFpbi5hdXRoMC5jb20iLCJzdWIiOiJsb2dpbiIsImlzcyI6ImF1dGgwIiwiZXh0cmFDbGFpbSI6IkpvaG4gRG9lIn0.2_0nxDPJwOk64U5V5V9pt8U92jTPJbGsHYQ35HYhbdE");
    expect(jwt, isValid);
    expect(jwt.claims, isNotNull);
    expect(jwt.claims, isA<Map>());
    expect(jwt.claims["exp"], isNotNull);
    expect(jwt.claims["iat"], isNotNull);
    expect(jwt.claims["nbf"], isNotNull);
    expect(jwt.claims["jti"], isNotNull);
    expect(jwt.claims["aud"], isNotNull);
    expect(jwt.claims["sub"], isNotNull);
    expect(jwt.claims["iss"], isNotNull);
    expect(jwt.claims["extraClaim"], isNotNull);
  });

  test('Should serialize and deserialize', () {
    final originalJwt = JWT.decode("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjEyMzQ1Njc4OTAsImlhdCI6MTIzNDU2Nzg5MCwibmJmIjoxMjM0NTY3ODkwLCJqdGkiOiJodHRwczovL2p3dC5pby8iLCJhdWQiOiJodHRwczovL2RvbWFpbi5hdXRoMC5jb20iLCJzdWIiOiJsb2dpbiIsImlzcyI6ImF1dGgwIiwiZXh0cmFDbGFpbSI6IkpvaG4gRG9lIn0.2_0nxDPJwOk64U5V5V9pt8U92jTPJbGsHYQ35HYhbdE");

    Map<String, dynamic> json = {};
    try {
      json = originalJwt.toJson();
    }
    catch(e) {
       throw 'Object is not serializable';
    }
    
    DecodedJWT deserializedJwt = JWTDecoder.fromJson(json);

    expect(originalJwt.header, deserializedJwt.header);
    expect(originalJwt.payload, deserializedJwt.payload);
    expect(originalJwt.signature, deserializedJwt.signature);
    expect(originalJwt.token, deserializedJwt.token);
    expect(originalJwt.algorithm, deserializedJwt.algorithm);
    expect(originalJwt.audience, deserializedJwt.audience);
    expect(originalJwt.contentType, deserializedJwt.contentType);
    expect(originalJwt.expiresAt, deserializedJwt.expiresAt);
    expect(originalJwt.id, deserializedJwt.id);
    expect(originalJwt.issuedAt, deserializedJwt.issuedAt);
    expect(originalJwt.issuer, deserializedJwt.issuer);
    expect(originalJwt.keyId, deserializedJwt.keyId);
    expect(originalJwt.notBefore, deserializedJwt.notBefore);
    expect(originalJwt.subject, deserializedJwt.subject);
    expect(originalJwt.type, deserializedJwt.type);
    expect(originalJwt.claims['extraClaim']?.asString(),
      deserializedJwt.claims['extraClaim']?.asString());
  });

  test('Should decode header claims', () {
    String jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImRhdGUiOjE2NDczNTgzMjUsInN0cmluZyI6InN0cmluZyIsImJvb2wiOnRydWUsImRvdWJsZSI6MTIzLjEyMywibGlzdCI6WzE2NDczNTgzMjVdLCJtYXAiOnsiZGF0ZSI6MTY0NzM1ODMyNSwiaW5zdGFudCI6MTY0NzM1ODMyNX0sImludCI6NDIsImxvbmciOjQyMDAwMDAwMDAsImluc3RhbnQiOjE2NDczNTgzMjV9.eyJpYXQiOjE2NDczNjA4ODF9.S2nZDM03ZDvLMeJLWOIqWZ9kmYHZUueyQiIZCCjYNL8";
  
    DateTime expectedDate = DateTime.fromMillisecondsSinceEpoch(1647358325*1000);
  
    DecodedJWT decoded = JWT.decode(jwt);
    expect(decoded, isValid);
    expect(decoded.headerClaim("date").asDateTime(), expectedDate);
    expect(decoded.headerClaim("string").asString(), "string");
    expect(decoded.headerClaim("bool").asBoolean(), isTrue);
    expect(decoded.headerClaim("double").asDouble(), 123.123);
    expect(decoded.headerClaim("int").asInt(), 42);
    expect(decoded.headerClaim("long").asInt(), 4200000000);

    Map<String, dynamic>? headerMap = decoded.headerClaim("map").asMap<dynamic>();
    expect(headerMap, isNotNull);
    expect(headerMap?.length, 2);
    expect(headerMap, containsPair("date", 1647358325));
    expect(headerMap, containsPair("instant", 1647358325));
  
    List<dynamic>? headerList = decoded.headerClaim("list").asList<dynamic>();
    expect(headerList, isNotNull);
    expect(headerList?.length, 1);
    expect(headerList, contains(1647358325));
  });

}

DecodedJWT _customJWT(String jsonHeader, String jsonPayload, String signature) {
  String header = base64.encode(jsonHeader.codeUnits);
  String body = base64.encode(jsonPayload.codeUnits);
  return JWT.decode('$header.$body.$signature');
}
