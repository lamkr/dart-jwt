import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:pointycastle/pointycastle.dart' hide Algorithm;

class RSAAlgorithm extends Algorithm {

  final CryptoHelper _crypto;
  final RSAKeyProvider _keyProvider;

  /// Visible for testing.
  RSAAlgorithm.withCryptoHelper(this._crypto, super.name, super.algorithm,
      this._keyProvider);
  
  RSAAlgorithm(String name, String algorithm, RSAKeyProvider keyProvider)
    : this.withCryptoHelper(const CryptoHelper(), name, algorithm, keyProvider);

  @override
  String get signingKeyId => _keyProvider.privateKeyId;

  @override
  Uint8List sign(Uint8List contentBytes) {
    try {
      final privateKey = Uint8List.fromList(_keyProvider.privateKey.toString().codeUnits);
      return _crypto.createSignatureForContent(description, privateKey
          , contentBytes);
    }
    on Error catch (error) {
      throw SignatureGenerationException.withError(this, error);
    }
    catch (e) {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  @override
  Uint8List signParts(Uint8List headerBytes, Uint8List payloadBytes) {
    try {
      final privateKey = Uint8List.fromList(_keyProvider.privateKey.toString().codeUnits);
      return _crypto.createSignatureFor(
          description, privateKey, headerBytes, payloadBytes);
    }
    on Error catch (error) {
      throw SignatureGenerationException.withError(this, error);
    }
    catch (e) {
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
      final privateKey = Uint8List.fromList(_keyProvider.privateKey.toString().codeUnits);
      final valid = _crypto.verifySignatureFor(
          description, privateKey, header, payload, signatureBytes);
      if (!valid) {
        throw SignatureVerificationException(this);
      }
    }
    on Error catch (error) {
      throw SignatureGenerationException.withError(this, error);
    }
    catch (e) {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  //Visible for testing
  static RSAKeyProvider providerForKeys(RSAPublicKey publicKey, RSAPrivateKey privateKey) {
    return RSAKeyProvider(publicKey, privateKey, '');
  }

}
