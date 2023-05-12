import '../interfaces/decoded_jwt.dart';
import 'jwt_decoder.dart';

class JWT {
  /// Decode a given Json Web {token}.
  ///
  /// Note that this method *doesn't verify the token's signature!*
  /// Use it only if you trust the token or if you have already verified it.
  ///
  /// @throws JWTDecodeException if any part of the token contained an invalid jwt
  /// or JSON format of each of the jwt parts.
  static DecodedJWT decode(String token) {
    return JWTDecoder(token);
  }
}
