import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:pointycastle/pointycastle.dart';

class CryptoHelper
{
  static const int jwtPartSeparator = 46; // '.'

  const CryptoHelper();

  /// Verify signature for JWT header and payload, using
  /// [algorithm] name, algorithm [secret],
  /// JWT [header], JWT [payload], JWT [signature].
  /// Throws [NoSuchAlgorithmException] if the algorithm is not supported or
  /// [InvalidKeyException] if the given key is inappropriate for initializing
  /// the specified algorithm.
  bool verifySignatureFor( String algorithm, Uint8List secret,
      Uint8List header, Uint8List payload, Uint8List signature
  )
  {
    final signatureForContent = createSignatureFor(algorithm, secret, header, payload);
    return ListEquality().equals(signatureForContent, signature);
  }

  /// Verify signature for JWT header and payload using a public key.
  /// Using [algorithm] name, [publicKey] to use for verification,
  /// JWT [header], JWT [payload], JWT [signatureBytes].
  /// Throws [NoSuchAlgorithmException] if the algorithm is not supported or
  /// [InvalidKeyException] if the given key is inappropriate for initializing
  /// the specified algorithm.
  bool verifySignatureUsingPublicKey(
    String algorithm,
    PublicKey publicKey,
    Uint8List header,
    Uint8List payload,
    Uint8List signatureBytes )
  {
    final signer = Signer(algorithm);
    final parameters = PublicKeyParameter(publicKey);
    signer.init(false, parameters);
    final content = Uint8List.fromList(header);
    content.add(jwtPartSeparator);
    content.addAll(payload);
    final signature = signer.generateSignature(signatureBytes);
    return signer.verifySignature(content, signature);
  }

  /// Create signature bytes for JWT header and payload using a private key.
  /// Using [algorithm] name, the [privateKey] to use for signing,
  /// JWT [header], JWT [payload].
  /// Throws [NoSuchAlgorithmException] if the algorithm is not supported.
  /// Or [InvalidKeyException] if the given key is inappropriate for
  /// initializing the specified algorithm.
  /// Or [SignatureException] if this signature object is not initialized
  /// properly or if this signature algorithm is unable to process
  /// the input data provided.
  Uint8List createSignatureForUsingPrivateKey(
    String algorithm,
    PrivateKey privateKey,
    Uint8List header,
    Uint8List payload
    )
  {
    final signer = Signer(algorithm);
    final parameters = PrivateKeyParameter(privateKey);
    signer.init(true, parameters);
    final content = Uint8List.fromList(header);
    content.add(jwtPartSeparator);
    content.addAll(payload);
    final signature = signer.generateSignature(content);
    final signatureBytes = Uint8List.fromList(signature.toString().codeUnits);
    return signatureBytes;
  }

  /// Create signature bytes for JWT header and payload.
  /// Using [algorithm] name, the algorithm [secret], JWT [header],
  /// JWT [payload].
  /// Throws [NoSuchAlgorithmException] if the algorithm is not supported.
  /// Or [InvalidKeyException] if the given key is inappropriate for
  /// initializing the specified algorithm.
  Uint8List createSignatureFor(
      String algorithm,
      Uint8List secret,
      Uint8List header,
      Uint8List payload
      )
  {
    final mac = Mac(algorithm);
    final secretKey = KeyParameter(secret);
    mac.init(secretKey);
    mac.update(header, 0, header.length);
    mac.updateByte(jwtPartSeparator);
    mac.update(payload, 0, payload.length);
    final output = Uint8List(mac.macSize);
    mac.doFinal(output, 0);
    return output;
  }

  /// Create signature bytes for JWT header and payload.
  /// Using [algorithm] name, the algorithm [secret], JWT [header],
  /// JWT [payload].
  /// Throws [NoSuchAlgorithmException] if the algorithm is not supported.
  /// Or [InvalidKeyException] if the given key is inappropriate for
  /// initializing the specified algorithm.
  Uint8List createSignatureForContent( String algorithm, Uint8List secret,
      Uint8List content )
  {
    final mac = Mac(algorithm);
    final secretKey = KeyParameter(secret);
    mac.init(secretKey);
    mac.update(content, 0, content.length);
    final output = Uint8List(mac.macSize);
    mac.doFinal(output, 0);
    return output;
  }
}