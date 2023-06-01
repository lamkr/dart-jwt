import 'package:dart_jwt/interfaces.dart';
import 'package:pointycastle/pointycastle.dart';

class RSAKeyProvider
    implements KeyProvider<RSAPublicKey, RSAPrivateKey>
{
  final RSAPublicKey _publicKey;
  final RSAPrivateKey _privateKey;
  final String _privateKeyId;

  RSAKeyProvider(this._publicKey, this._privateKey, this._privateKeyId);

  @override
  RSAPrivateKey get privateKey => _privateKey;

  @override
  String get privateKeyId => _privateKeyId;

  @override
  RSAPublicKey publicKeyById(String keyId) => _publicKey;
}