import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

void main() {
  test('Should pass none verification', () {
    const jwt = "eyJhbGciOiJub25lIiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.";
    Algorithm algorithm = Algorithm.none;
    algorithm.verify(JWT.decode(jwt));
  });

  test('Should fail none verification when token has two parts', () {
    try {
      const jwt = "eyJhbGciOiJub25lIiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9";
      Algorithm algorithm = Algorithm.none;
      algorithm.verify(JWT.decode(jwt));
    } catch (e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          'The token was expected to have 3 parts, but got 2.');
    }
  });

  test('Should fail none verification when signature is present', () {
    try {
      const jwt = "eyJhbGciOiJub25lIiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.Ox-WRXRaGAuWt2KfPvWiGcCrPqZtbp_4OnQzZXaTfss=";
      Algorithm algorithm = Algorithm.none;
      algorithm.verify(JWT.decode(jwt));
    } catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).message,
          "The Token's Signature resulted invalid when verified using the Algorithm: none");
    }
  });

  test('Should return null signing key id', () {
    expect(Algorithm.none.signingKeyId, isNull);
  });

  test('Should throw when signature not valid base 64', () {
    try {
      const jwt = "eyJhbGciOiJub25lIiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.Ox-WRXRaGAuWt2KfPvW§iGcCrPqZtbp_4OnQzZXaTfss";
      Algorithm algorithm = Algorithm.none;
      final jwtDecoded = JWT.decode(jwt);
      algorithm.verify(jwtDecoded);
    } catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).cause,
          isA<FormatException>() );
    }
  });

}
