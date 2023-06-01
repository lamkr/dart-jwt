import 'dart:io';
import 'dart:typed_data';

import 'package:dart_jwt/pem.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/api.dart';

class PemUtils
{
  static Uint8List parsePEMFile(File pemFile) {
    final reader = PemReader( pemFile.readAsLinesSync() );
    final pemObject = reader.readPemObject();
    return pemObject.content;
  }

  static PublicKey getPublicKey(Uint8List bytes, String algorithm) {
    /*PublicKey publicKey = null;
    RSAKeyParser().parse(publicPem) as RSAPublicKey;
    try {
      KeyFactory kf = KeyFactory.getInstance(algorithm);
      EncodedKeySpec keySpec = X509EncodedKeySpec(keyBytes);
      publicKey = kf.generatePublic(keySpec);
    } catch (NoSuchAlgorithmException e) {
    System.out.println("Could not reconstruct the public key, the given algorithm could not be found.");
    } catch (InvalidKeySpecException e) {
    System.out.println("Could not reconstruct the public key");
    }
    return publicKey;*/
    // TODO: implement readLine
    throw UnimplementedError();
  }

  static PrivateKey getPrivateKey(Uint8List bytes, String algorithm) {
    // TODO: implement readLine
    throw UnimplementedError();
  }
}