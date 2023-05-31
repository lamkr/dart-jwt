import 'dart:typed_data';
import 'dart:io';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:pointycastle/pointycastle.dart' hide Algorithm;
import 'package:test/test.dart';

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
}

PublicKey readPublicKeyFromFile(String filepath, String algorithm) {
  final file = File(filepath);
  Uint8List bytes = PemUtils.parsePEMFile(file);
  return PemUtils.getPublicKey(bytes, algorithm);
}

PrivateKey readPrivateKeyFromFile(String filepath, String algorithm) {
  final file = File(filepath);
  Uint8List bytes = PemUtils.parsePEMFile(file);
  return PemUtils.getPrivateKey(bytes, algorithm);
}
