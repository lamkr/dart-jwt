import 'dart:typed_data';

import 'package:dart_jwt/interfaces.dart';

import 'none_algorithm.dart';

abstract class Algorithm {
  static const Algorithm none = NoneAlgorithm();

  final String name;
  final String description;

  const Algorithm(this.name, this.description);

  /// Getter for the Id of the Private Key used to sign the tokens.
  /// This is usually specified as the `kid` claim in the Header.
  String get signingKeyId => '';

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