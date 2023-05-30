import 'dart:convert';
import 'dart:typed_data';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces.dart';
import 'algorithm.dart';

class NoneAlgorithm extends Algorithm
{
  const NoneAlgorithm(): super('none', 'none');

  @override
  void verify(DecodedJWT jwt) {
    try {
      final signatureBytes = base64Decode(jwt.signature);
      if (signatureBytes.isNotEmpty) {
        throw SignatureVerificationException(this);
      }
    } on FormatException catch (e) {
      throw SignatureVerificationException(this, e);
    }
  }

  @override
  Uint8List signParts(Uint8List headerBytes, Uint8List payloadBytes) => Uint8List(0);

  @override
  Uint8List sign(Uint8List contentBytes) => Uint8List(0);
}
