import 'dart:typed_data';

import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:pointycastle/pointycastle.dart';

abstract class Algorithm {
  static const Algorithm none = NoneAlgorithm();

  static Algorithm hmac256(Uint8List secret) =>
      HmacAlgorithm("HS256", "SHA-256/HMAC", secret);

  static Algorithm hmac384(Uint8List secret) =>
      HmacAlgorithm("HS384", "SHA-384/HMAC", secret);

  static Algorithm hmac512(Uint8List secret) =>
      HmacAlgorithm("HS512", "SHA-512/HMAC", secret);

  /// Creates a new Algorithm instance using SHA-256/RSA.
  /// Tokens specify this as "RS256".
  static Algorithm rsa256(RSAAsymmetricKey key) {
    RSAPublicKey? publicKey =
        key is RSAPublicKey ? key : RSAPublicKey(BigInt.zero, BigInt.zero);
    RSAPrivateKey? privateKey =
        key is RSAPrivateKey ? key : RSAPrivateKey(BigInt.zero, BigInt.zero
            , BigInt.zero, BigInt.zero);
    return rsa256WithKeys(publicKey, privateKey);
  }

  /// Creates a new Algorithm instance using SHA-256/RSA.
  /// Tokens specify this as "RS256".
  static Algorithm rsa256WithKeys(RSAPublicKey publicKey, RSAPrivateKey privateKey) {
    final keyProvider = RSAAlgorithm.providerForKeys(publicKey, privateKey);
    return rsa256WithKeyProvider(keyProvider);
  }

  /// Creates a new Algorithm instance using SHA-256/RSA.
  /// Tokens specify this as "RS256".
  static Algorithm rsa256WithKeyProvider(RSAKeyProvider keyProvider) {
    return RSAAlgorithm("RS256", "SHA-256/RSA", keyProvider);
  }

  final String name;
  final String description;

  const Algorithm(this.name, this.description);

  /// Getter for the Id of the Private Key used to sign the tokens.
  /// This is usually specified as the `kid` claim in the Header.
  String? get signingKeyId => null;

  /// Verify the given token using this Algorithm instance.
  /// Throws [SignatureVerificationException] if the Token's Signature is invalid,
  /// meaning that it doesn't match the signatureBytes, or if the Key is invalid.
  void verify(DecodedJWT jwt);

  /// Sign the given content using this [Algorithm] instance.
  /// [headerBytes] is an list of bytes representing the base64 encoded header
  /// content to be verified against the signature.
  //  [payloadBytes] an list of bytes representing the base64 encoded payload
  //  content to be verified against the signature.
  /// Returns the signature in a base64 encoded bytes.
  /// Throws [SignatureGenerationException] if the Key is invalid.
  Uint8List signParts(Uint8List headerBytes, Uint8List payloadBytes) {
    final contentBytes = Uint8List(headerBytes.length+1+payloadBytes.length);
    contentBytes.addAll(headerBytes);
    contentBytes.addAll('.'.codeUnits);
    contentBytes.addAll(payloadBytes);
    return sign(contentBytes);
  }


  /// Sign the given base64 encoded [contentBytes] using this
  /// [Algorithm] instance.
  /// To get the correct JWT Signature, ensure the content is in the format
  /// {HEADER}.{PAYLOAD}.
  /// Returns the signature in a base64 encoded bytes.
  /// Throws [SignatureGenerationException] if the Key is invalid.
  Uint8List sign(Uint8List contentBytes);

  @override
  String toString() => description;
}