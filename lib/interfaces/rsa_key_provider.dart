import 'package:dart_jwt/interfaces.dart';
import 'package:pointycastle/pointycastle.dart';

abstract class RSAKeyProvider
    implements KeyProvider<RSAPublicKey, RSAPrivateKey>
{}