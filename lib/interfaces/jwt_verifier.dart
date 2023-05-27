import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/extensions.dart';

import 'decoded_jwt.dart';

/// Used to verify the JWT for its signature and claims.
/// Implementations must be thread-safe. Instances are created
/// using [Verification].
/// `
///  try {
///    JWTVerifier verifier = JWTVerifier.init(Algorithm.RSA256(publicKey, privateKey)
///      .withIssuer("auth0")
///      .build();
///    DecodedJWT jwt = verifier.verify("token");
/// } catch (e) {
///    // invalid signature or claims
/// }
/// `
abstract class JWTVerifier implements NullSafetyObject {

  static const invalid = _InvalidJWTVerifier();

  const JWTVerifier();

  /// Performs the verification against the given [token]
  /// and returns a verified and decoded JWT.
  /// Throws [JWTVerificationException] if any of the verification steps fail.
  DecodedJWT verify(String token);

  /// Performs the verification against the given [DecodedJWT]
  /// and returns a verified and decoded JWT.
  /// Throws [JWTVerificationException] if any of the verification steps fail.
  DecodedJWT verifyDecoded(DecodedJWT jwt);
}

class _InvalidJWTVerifier extends JWTVerifier {

  const _InvalidJWTVerifier(): super();

  @override
  bool get isValid => false;

  @override
  bool get isNotValid => !isValid;

  @override
  DecodedJWT verify(String token) =>
      throw InvalidObjectException(runtimeType);

  @override
  DecodedJWT verifyDecoded(DecodedJWT jwt) =>
      throw InvalidObjectException(runtimeType);

}