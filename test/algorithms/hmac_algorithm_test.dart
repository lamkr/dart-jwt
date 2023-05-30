import 'dart:typed_data';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

void main() {
  test('Should get string bytes', () {
    const text = "abcdef123456!@#\$%^";
    final expectedBytes = text.codeUnits;
    expect(expectedBytes, HmacAlgorithm.getSecretBytes(text));
  });

  test('Should copy the received secret list', () {
    const jwt = "eyJhbGciOiJIUzI1NiIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.mZ0m_N1J4PgeqWmi903JuUoDRZDBPB7HwkS4nVyWH1M=";
    final secret = Uint8List.fromList("secret".codeUnits);
    final algorithm = Algorithm.hmac256(secret);
    final decoded = JWT.decode(jwt);
    algorithm.verify(decoded);
    secret[0] = secret[1];
    algorithm.verify(decoded);
  });

  test('shouldFailHMAC256VerificationWithInvalidSecretBytes', () {
    try {
      const jwt = "eyJhbGciOiJIUzI1NiIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.mZ0m_N1J4PgeqWmi903JuUoDRZDBPB7HwkS4nVyWH1M";
      final secret = Uint8List.fromList("not_real_secret".codeUnits);
      final algorithm = Algorithm.hmac256(secret);
      algorithm.verify(JWT.decode(jwt));
    }
    catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).message,
          "The Token's Signature resulted invalid when verified using the Algorithm: SHA-256/HMAC");
    }
  });

  test('shouldPassHMAC384Verification', () {
    const jwt = "eyJhbGciOiJIUzM4NCIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.uztpK_wUMYJhrRv8SV-1LU4aPnwl-EM1q-wJnqgyb5DHoDteP6lN_gE1xnZJH5vw";
    final secret = Uint8List.fromList("secret".codeUnits);
    final algorithm = Algorithm.hmac384(secret);
    final decoded = JWT.decode(jwt);
    algorithm.verify(decoded);
  });

  test('shouldFailHMAC348VerificationWithInvalidSecretBytes', () {
    try {
      const jwt = "eyJhbGciOiJIUzM4NCIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.uztpK_wUMYJhrRv8SV-1LU4aPnwl-EM1q-wJnqgyb5DHoDteP6lN_gE1xnZJH5vw";
      final secret = Uint8List.fromList("not_real_secret".codeUnits);
      final algorithm = Algorithm.hmac384(secret);
      algorithm.verify(JWT.decode(jwt));
    }
    catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).message,
          "The Token's Signature resulted invalid when verified using the Algorithm: SHA-384/HMAC");
    }
  });

  test('shouldPassHMAC512Verification', () {
    const jwt = "eyJhbGciOiJIUzUxMiIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.VUo2Z9SWDV-XcOc_Hr6Lff3vl7L9e5Vb8ThXpmGDFjHxe3Dr1ZBmUChYF-xVA7cAdX1P_D4ZCUcsv3IefpVaJw";
    final secret = Uint8List.fromList("secret".codeUnits);
    final algorithm = Algorithm.hmac512(secret);
    final decoded = JWT.decode(jwt);
    algorithm.verify(decoded);
  });

  test('shouldFailHMAC512VerificationWithInvalidSecretBytes', () {
    try {
      const jwt = "eyJhbGciOiJIUzUxMiIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.VUo2Z9SWDV-XcOc_Hr6Lff3vl7L9e5Vb8ThXpmGDFjHxe3Dr1ZBmUChYF-xVA7cAdX1P_D4ZCUcsv3IefpVaJw";
      final secret = Uint8List.fromList("not_real_secret".codeUnits);
      final algorithm = Algorithm.hmac512(secret);
      algorithm.verify(JWT.decode(jwt));
    }
    catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).message,
          "The Token's Signature resulted invalid when verified using the Algorithm: SHA-512/HMAC");
    }
  });

  test('shouldThrowOnVerifyWhenSignatureAlgorithmDoesNotExists', () {
    try {
      CryptoHelper crypto = CryptoHelperMock(throwsWhenVerify: NoSuchAlgorithmException());
      final secret = Uint8List.fromList("secret".codeUnits);
      final algorithm = HmacAlgorithm.withCryptoHelper(crypto, "some-alg", "some-algorithm", secret);
      const jwt = "eyJhbGciOiJIUzI1NiIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.mZ0m_N1J4PgeqWmi903JuUoDRZDBPB7HwkS4nVyWH1M";
      algorithm.verify(JWT.decode(jwt));
    }
    catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).message,
          "The Token's Signature resulted invalid when verified using the Algorithm: some-algorithm");
      expect(e.cause,
          isA<NoSuchAlgorithmException>());
    }
  });

  test('shouldThrowOnSignWhenTheSecretIsInvalid', () {
    try {
      CryptoHelper crypto = CryptoHelperMock(throwsWhenCreate: InvalidKeyException());
      final secret = Uint8List.fromList("secret".codeUnits);
      final algorithm = HmacAlgorithm.withCryptoHelper(crypto, "some-alg", "some-algorithm", secret);
      algorithm.signParts(Uint8List.fromList([]), Uint8List.fromList([]));
    }
    catch (e) {
      expect(e, isA<SignatureGenerationException>());
      expect((e as SignatureGenerationException).message,
          "The Token's Signature couldn't be generated when signing using the Algorithm: some-algorithm");
      expect(e.cause,
          isA<InvalidKeyException>());
    }
  });

  test('shouldReturnNullSigningKeyId', () {
    final secret = Uint8List.fromList("secret".codeUnits);
    final algorithm = Algorithm.hmac256(secret);
    expect(algorithm.signingKeyId, isNull);
  });

  test('shouldBeEqualSignatureMethodResults', () {
    final secret = Uint8List.fromList("secret".codeUnits);
    final algorithm = Algorithm.hmac256(secret);

    Uint8List header = Uint8List.fromList([0x00, 0x01, 0x02]);
    Uint8List payload = Uint8List.fromList([0x04, 0x05, 0x06]);

    final bout = Uint8List.fromList(<int>[ ...header, ...'.'.codeUnits, ...payload]);
    expect(algorithm.sign(bout), algorithm.signParts(header, payload));
  });

  test('shouldThrowWhenSignatureNotValidBase64', () {
    try {
      CryptoHelper crypto = CryptoHelperMock(throwsWhenVerify: NoSuchAlgorithmException());
      final secret = Uint8List.fromList("secret".codeUnits);
      final algorithm = HmacAlgorithm.withCryptoHelper(crypto, "some-alg", "some-algorithm", secret);
      const jwt = "eyJhbGciOiJIUzI1NiIsImN0eSI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.mZ0m_N1J4PgeqWm§i903JuUoDRZDBPB7HwkS4nVyWH1M";
      algorithm.verify(JWT.decode(jwt));
    }
    catch (e) {
      expect(e, isA<SignatureVerificationException>());
      expect((e as SignatureVerificationException).cause,
          isA<FormatException>());
    }
  });


}

class CryptoHelperMock extends CryptoHelper {
  final Exception? throwsWhenVerify;
  final Exception? throwsWhenCreate;

  CryptoHelperMock({this.throwsWhenVerify, this.throwsWhenCreate});

  @override
  bool verifySignatureFor(String algorithm, Uint8List secret, Uint8List header, Uint8List payload, Uint8List signature) {
    if(throwsWhenVerify == null) {
      return super.verifySignatureFor(algorithm, secret, header, payload, signature);
    }
    throw throwsWhenVerify!;
  }

  @override
  Uint8List createSignatureFor(String algorithm, Uint8List secret,
      Uint8List header, Uint8List payload )
  {
    if(throwsWhenCreate == null) {
      super.createSignatureFor(algorithm, secret, header, payload);
    }
    throw throwsWhenCreate!;
  }

}