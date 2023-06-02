import 'package:test/test.dart';

void main() {
  test('test', () {
    //ERROR final p = PublicKeyParameter<PublicKey>();
    final p = PublicKeyParameter<RSAPublicKey>();
    Engine().init(true, p);
  });
}

abstract class AsymmetricKey {}

abstract class PublicKey implements AsymmetricKey {}

abstract class RSAAsymmetricKey implements AsymmetricKey {}

class RSAPublicKey extends RSAAsymmetricKey implements PublicKey {}

abstract class CipherParameters {}

abstract class AsymmetricKeyParameter<T extends AsymmetricKey>
    implements CipherParameters {}

class PublicKeyParameter<T extends PublicKey> extends AsymmetricKeyParameter<T> {}

class Engine {
  void init(bool forEncryption,
      covariant AsymmetricKeyParameter<RSAAsymmetricKey> params) {
    print(params);
  }
}