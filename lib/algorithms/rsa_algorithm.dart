import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/security.dart';
import 'package:pointycastle/export.dart' hide Algorithm;

class RSAAlgorithm extends Algorithm {
  final CryptoHelper _crypto;
  final RSAKeyProvider _keyProvider;

  /// Visible for testing.
  RSAAlgorithm.withCryptoHelper(
      this._crypto, super.name, super.algorithm, this._keyProvider);

  RSAAlgorithm(String name, String algorithm, RSAKeyProvider keyProvider)
      : this.withCryptoHelper(
            const CryptoHelper(), name, algorithm, keyProvider);

  @override
  String get signingKeyId => _keyProvider.privateKeyId;

  @override
  Uint8List sign(Uint8List contentBytes) {
    try {
      final privateKey =
          Uint8List.fromList(_keyProvider.privateKey.toString().codeUnits);
      return _crypto.createSignatureForContent(
          description, privateKey, contentBytes);
    } on Error catch (error) {
      throw SignatureGenerationException.withError(this, error);
    } catch (e) {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  @override
  Uint8List signParts(Uint8List headerBytes, Uint8List payloadBytes) {
    try {
      final privateKey =
          Uint8List.fromList(_keyProvider.privateKey.toString().codeUnits);
      return _crypto.createSignatureFor(
          description, privateKey, headerBytes, payloadBytes);
    } on Error catch (error) {
      throw SignatureGenerationException.withError(this, error);
    } catch (e) {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  @override
  void verify(DecodedJWT jwt) {
    try {
      final publicKey = _keyProvider.publicKeyById(jwt.keyId);
      if( publicKey == RSAKeys.invalidRSAPublicKey ) {
        throw SignatureVerificationException(
            this, InvalidObjectException(publicKey.runtimeType));
      }
      final normalized = base64.normalize(jwt.signature);
      Uint8List signatureBytes = base64.decode(normalized);
      final header = Uint8List.fromList(jwt.header.codeUnits);
      final payload = Uint8List.fromList(jwt.payload.codeUnits);
      final valid = _verifyWithPublicKey(
          description, publicKey, header, payload, signatureBytes);
      if (!valid) {
        throw SignatureVerificationException(this);
      }
    } on Error catch (error) {
      throw SignatureGenerationException.withError(this, error);
    } on SignatureVerificationException catch (e) {
      rethrow;
    } catch (e) {
      throw SignatureGenerationException(this, e as Exception?);
    }
  }

  static const int _jwtPartSeparator = 46; // '.'

  /// Verify signature for JWT header and payload using a public key.
  /// Using [algorithm] name, [publicKey] to use for verification,
  /// JWT [header], JWT [payload], JWT [signatureBytes].
  /// Throws [NoSuchAlgorithmException] if the algorithm is not supported or
  /// [InvalidKeyException] if the given key is inappropriate for initializing
  /// the specified algorithm.
  bool _verifyWithPublicKey(String algorithm, RSAPublicKey publicKey,
      Uint8List header, Uint8List payload, Uint8List signatureBytes) {
    final verifier = Signer('SHA-256/RSA');
    final parameters = PublicKeyParameter<RSAPublicKey>(publicKey);
    verifier.init(false, parameters);
    final signedData = Uint8List.fromList([
      ...header,
      ...[_jwtPartSeparator],
      ...payload,
    ]);
    final signature = RSASignature(signatureBytes);
    return verifier.verifySignature(signedData, signature);
  }

  //Visible for testing
  static RSAKeyProvider providerForKeys(
      RSAPublicKey publicKey, RSAPrivateKey privateKey) {
    return RSAKeyProvider(publicKey, privateKey, '');
  }
}
