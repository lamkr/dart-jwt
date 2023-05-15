import 'dart:convert';

import 'package:dart_jwt/exceptions/jwt_decode_exception.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

void main() {
  test('getSubject', () {
    DecodedJWT jwt = JWT.decode(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ');
    expect(jwt.subject, isNotEmpty);
    expect(jwt.subject, '1234567890');
    expect(jwt.issuer, isEmpty);
    expect(jwt.id, isEmpty);
  });

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
    const validJson = "{}";
    const invalidJson = "}{";
    try {
      _customJWT(validJson, invalidJson, "signature");
    }
    catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(),
          "The string '$invalidJson' doesn't have a valid JSON format.");
    }
  });
}

DecodedJWT _customJWT(String jsonHeader, String jsonPayload, String signature) {
  final headerBytes = base64.decode(jsonHeader);
  final payloadBytes = base64.decode(jsonPayload);
  String header = String.fromCharCodes(headerBytes);
  String body = String.fromCharCodes(payloadBytes);
  return JWT.decode("$header.$body.$signature");
}

