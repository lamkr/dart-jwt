import 'package:pointycastle/pointycastle.dart';

class RSAKeys {
  static final invalidRSAPublicKey = RSAPublicKey(BigInt.zero, BigInt.zero);
  static final invalidRSAPrivateKey = RSAPrivateKey(BigInt.zero, BigInt.zero,
    BigInt.zero, BigInt.zero);
}
