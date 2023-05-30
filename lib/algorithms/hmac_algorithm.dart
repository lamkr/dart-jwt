import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces/decoded_jwt.dart';

class HmacAlgorithm extends Algorithm {

  static Uint8List getSecretBytes(String secret) =>
      Uint8List.fromList(secret.codeUnits);

  final CryptoHelper _crypto;
  final Uint8List _secret;

  /// Visible for testing.
  HmacAlgorithm.withCryptoHelper(this._crypto, super.name, super.algorithm,
      Uint8List secret)
  : _secret = Uint8List.fromList(secret);

  HmacAlgorithm(String name, String algorithm, Uint8List secret)
    : this.withCryptoHelper(const CryptoHelper(), name, algorithm, secret);

  @override
  Uint8List sign(Uint8List contentBytes) {
    try {
      return _crypto.createSignatureForContent(description, _secret, contentBytes);
    }
    catch (e) //TODO in Java: (NoSuchAlgorithmException | InvalidKeyException e)
    {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  @override
  Uint8List signParts(Uint8List headerBytes, Uint8List payloadBytes) {
    try {
      return _crypto.createSignatureFor(
          description, _secret, headerBytes, payloadBytes);
    }
    catch (e) //TODO in Java: (NoSuchAlgorithmException | InvalidKeyException e)
    {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  @override
  void verify(DecodedJWT jwt) {
    try {
      final normalized = base64.normalize(jwt.signature);
      Uint8List signatureBytes = base64.decode(normalized);
      final header = Uint8List.fromList(jwt.header.codeUnits);
      final payload = Uint8List.fromList(jwt.payload.codeUnits);
      final valid = _crypto.verifySignatureFor(
          description, _secret, header, payload, signatureBytes);
      if (!valid) {
        throw SignatureVerificationException(this);
      }
    }
    catch (e) //TODO In java: (IllegalStateException | InvalidKeyException | NoSuchAlgorithmException | IllegalArgumentException e)
    {
      throw SignatureVerificationException(this, e as Exception?);
    }
  }
}
