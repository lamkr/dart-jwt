import 'dart:io';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:dart_jwt/security.dart';
import 'package:encrypt/encrypt.dart' hide Algorithm;
import 'package:pointycastle/pointycastle.dart' hide Algorithm;
import 'package:test/test.dart';

import '../pem_utils.dart';

void main() {
  const privateKeyFile = "assets/rsa-private.pem";
  const publicKeyFile = "assets/rsa-public.pem";
  const invalidPublicKeyFile = "assets/rsa-public_invalid.pem";

  test('shouldPassRSA256Verification', () {
    const jwt = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.dxXF3MdsyW-AuvwJpaQtrZ33fAde9xWxpLIg9cO2tMLH2GSRNuLAe61KsJusZhqZB9Iy7DvflcmRz-9OZndm6cj_ThGeJH2LLc90K83UEvvRPo8l85RrQb8PcanxCgIs2RcZOLygERizB3pr5icGkzR7R2y6zgNCjKJ5_NJ6EiZsGN6_nc2PRK_DbyY-Wn0QDxIxKoA5YgQJ9qafe7IN980pXvQv2Z62c3XR8dYuaXBqhthBj-AbaFHEpZapN-V-TmuLNzR2MCB6Xr7BYMuCaqWf_XU8og4XNe8f_8w9Wv5vvgqMM1KhqVpG5VdMJv4o_L4NoCROHhtUQSLRh2M9cA";
    final secret = readPublicKeyFromFile(publicKeyFile, "RSA") as RSAPublicKey;
    final algorithm = Algorithm.rsa256(secret);
    algorithm.verify(JWT.decode(jwt));
  });

  test('shouldPassRSA256VerificationWithBothKeys', () {
    const jwt = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhdXRoMCJ9.dxXF3MdsyW-AuvwJpaQtrZ33fAde9xWxpLIg9cO2tMLH2GSRNuLAe61KsJusZhqZB9Iy7DvflcmRz-9OZndm6cj_ThGeJH2LLc90K83UEvvRPo8l85RrQb8PcanxCgIs2RcZOLygERizB3pr5icGkzR7R2y6zgNCjKJ5_NJ6EiZsGN6_nc2PRK_DbyY-Wn0QDxIxKoA5YgQJ9qafe7IN980pXvQv2Z62c3XR8dYuaXBqhthBj-AbaFHEpZapN-V-TmuLNzR2MCB6Xr7BYMuCaqWf_XU8og4XNe8f_8w9Wv5vvgqMM1KhqVpG5VdMJv4o_L4NoCROHhtUQSLRh2M9cA";
    final publicKey = readPublicKeyFromFile<RSAPublicKey>(
        publicKeyFile, "RSA");
    final privateKey = readPrivateKeyFromFile<RSAPrivateKey>(
        privateKeyFile, "RSA");
    final algorithm = Algorithm.rsa256WithKeys(publicKey, privateKey);
    algorithm.verify(JWT.decode(jwt));
  });

  test('shouldPassRSA256VerificationWithProvidedPublicKey', () {
    const jwt = "eyJhbGciOiJSUzI1NiIsImtpZCI6Im15LWtleS1pZCJ9.eyJpc3MiOiJhdXRoMCJ9.jXrbue3xJmnzWH9kU-uGeCTtgbQEKbch8uHd4Z52t86ncNyepfusl_bsyLJIcxMwK7odRzKiSE9efV9JaRSEDODDBdMeCzODFx82uBM7e46T1NLVSmjYIM7Hcfh81ZeTIk-hITvgtL6hvTdeJWOCZAB0bs18qSVW5SvursRUhY38xnhuNI6HOHCtqp7etxWAu6670L53I3GtXsmi6bXIzv_0v1xZcAFg4HTvXxfhfj3oCqkSs2nC27mHxBmQtmZKWmXk5HzVUyPRwTUWx5wHPT_hCsGer-CMCAyGsmOg466y1KDqf7ogpMYojfVZGWBsyA39LO1oWZ4Ryomkn8t5Vg";
    final publicKey = readPublicKeyFromFile<RSAPublicKey>(
        publicKeyFile, "RSA");
    final privateKey = readPrivateKeyFromFile<RSAPrivateKey>(
        privateKeyFile, "RSA");
    final keyProvider = RSAKeyProvider(publicKey, privateKey, "");
    final algorithm = Algorithm.rsa256WithKeyProvider(keyProvider);
    algorithm.verify(JWT.decode(jwt));
  });

  test('shouldFailRSA256VerificationWhenProvidedPublicKeyIsNull', () {
    const jwt = "eyJhbGciOiJSUzI1NiIsImtpZCI6Im15LWtleS1pZCJ9.eyJpc3MiOiJhdXRoMCJ9.jXrbue3xJmnzWH9kU-uGeCTtgbQEKbch8uHd4Z52t86ncNyepfusl_bsyLJIcxMwK7odRzKiSE9efV9JaRSEDODDBdMeCzODFx82uBM7e46T1NLVSmjYIM7Hcfh81ZeTIk-hITvgtL6hvTdeJWOCZAB0bs18qSVW5SvursRUhY38xnhuNI6HOHCtqp7etxWAu6670L53I3GtXsmi6bXIzv_0v1xZcAFg4HTvXxfhfj3oCqkSs2nC27mHxBmQtmZKWmXk5HzVUyPRwTUWx5wHPT_hCsGer-CMCAyGsmOg466y1KDqf7ogpMYojfVZGWBsyA39LO1oWZ4Ryomkn8t5Vg";
    final keyProvider = RSAKeyProvider(RSAKeys.invalidRSAPublicKey,
        RSAKeys.invalidRSAPrivateKey, '');
    final algorithm = Algorithm.rsa256WithKeyProvider(keyProvider);
    try {
      algorithm.verify(JWT.decode(jwt));
    }
    catch (e) {
      expect(e, isA<SignatureVerificationException>());
      final ex = (e as SignatureVerificationException);
      expect(ex.message,
          "The Token's Signature resulted invalid when verified using the Algorithm: SHA-256/RSA");
      final objType = RSAKeys.invalidRSAPublicKey.runtimeType;
      expect(ex.cause.toString(), 'This object of type $objType is invalid');
    }
  });
}

T readPublicKeyFromFile<T extends PublicKey>(String filepath, String algorithm) {
  final file = File(filepath);
  final pem = file.readAsStringSync();
  return RSAKeyParser().parse(pem) as T;
}

T readPrivateKeyFromFile<T extends PrivateKey>(String filepath, String algorithm) {
  final file = File(filepath);
  final pem = file.readAsStringSync();
  return RSAKeyParser().parse(pem) as T;
}
