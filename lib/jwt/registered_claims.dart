/// Contains constants representing the name of the Registered Claim Names
/// as defined in Section 4.1 of
/// <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1">RFC 7529</a>
class RegisteredClaims {

  RegisteredClaims._();

  /// The "iss" (issuer) claim identifies the principal that issued the JWT.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.1">Section 4.1.1</a>
  static const String issuer = "iss";

  /// The "sub" (subject) claim identifies the principal that is the subject of the JWT.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.2">Section 4.1.2</a>
  static const String subject = "sub";

  /// The "aud" (audience) claim identifies the recipients that the JWT is intended for.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.3">Section 4.1.3</a>
  static const String audience = "aud";

  /// The "exp" (expiration time) claim identifies the expiration time on or after which the JWT MUST NOT be
  /// accepted for processing.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.4">Section 4.1.4</a>
  static const String expiresAt = "exp";

  /// The "nbf" (not before) claim identifies the time before which the JWT MUST NOT be accepted for processing.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.5">Section 4.1.5</a>
  static const String notBefore = "nbf";

  /// The "iat" (issued at) claim identifies the time at which the JWT was issued.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.6">Section 4.1.6</a>
  static const String issuedAt = "iat";

  /// The "jti" (JWT ID) claim provides a unique identifier for the JWT.
  /// Refer RFC 7529 <a href="https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.7">Section 4.1.7</a>
  static const String jwtId = "jti";
}