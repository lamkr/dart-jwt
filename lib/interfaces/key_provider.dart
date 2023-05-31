import 'package:pointycastle/pointycastle.dart';

abstract class KeyProvider<U extends PublicKey, R extends PrivateKey>
{
  /// Getter for the [PublicKey] instance with the given [keyId].
  /// Used to verify the signature on the JWT verification stage.
  U publicKeyById(String keyId);

  /// Getter for the [PrivateKey] instance. Used to sign the content
  /// on the JWT signing stage.
  R get privateKey;

  /// Getter for the Id of the [PrivateKey] used to sign the tokens.
  /// This represents the `kid` claim and will be placed in the Header.
  String get privateKeyId;
}