import 'package:dart_jwt/exceptions/jwt_decode_exception.dart';
import 'package:dart_jwt/jwt/token_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Tolerates empty first part', () {
    String token = ".eyJpc3MiOiJhdXRoMCJ9.W1mx_Y0hbAMbPmfW9whT605AAcxB7REFuJiDAHk2Sdc";
    final parts = TokenUtils.splitToken(token);
  
    expect(parts, isNotNull);
    expect(parts.length, 3);
    expect(parts[0], isEmpty);
    expect(parts[1], "eyJpc3MiOiJhdXRoMCJ9");
    expect(parts[2], "W1mx_Y0hbAMbPmfW9whT605AAcxB7REFuJiDAHk2Sdc");
  });

  test('Tolerates empty second part', () {
    String token = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0..W1mx_Y0hbAMbPmfW9whT605AAcxB7REFuJiDAHk2Sdc";
    final parts = TokenUtils.splitToken(token);

    expect(parts, isNotNull);
    expect(parts.length, 3);
    expect(parts[0], "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0");
    expect(parts[1], isEmpty);
    expect(parts[2], "W1mx_Y0hbAMbPmfW9whT605AAcxB7REFuJiDAHk2Sdc");
  });

  test('Should split token', () {
    String token = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.W1mx_Y0hbAMbPmfW9whT605AAcxB7REFuJiDAHk2Sdc";
    final parts = TokenUtils.splitToken(token);

    expect(parts, isNotNull);
    expect(parts.length, 3);
    expect(parts[0], "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0");
    expect(parts[1], "eyJpc3MiOiJhdXRoMCJ9");
    expect(parts[2], "W1mx_Y0hbAMbPmfW9whT605AAcxB7REFuJiDAHk2Sdc");
  });

  test('Should split token with empty signature', () {
    String token = "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.";
    final parts = TokenUtils.splitToken(token);

    expect(parts, isNotNull);
    expect(parts.length, 3);
    expect(parts[0], "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0");
    expect(parts[1], "eyJpc3MiOiJhdXRoMCJ9");
    expect(parts[2], isEmpty);
  });

  test('Should throw on split token with more than 3 parts', () {
    try {
      String token = "this.has.four.parts";
      TokenUtils.splitToken(token);
    }
    catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(), "The token was expected to have 3 parts, but got > 3.");
    }
  });

  test('Should throw on split token with no parts', () {
    try {
      String token = "notajwt";
      TokenUtils.splitToken(token);
    }
    catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(), "The token was expected to have 3 parts, but got 0.");
    }
  });

  test('Should throw on split token with 2 parts', () {
    try {
      String token = "two.parts";
      TokenUtils.splitToken(token);
    }
    catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(), "The token was expected to have 3 parts, but got 2.");
    }
  });

  test('Should throw on split an empty token', () {
    try {
      TokenUtils.splitToken('');
    }
    catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect(
          e.toString(), "The token is empty.");
    }
  });

}