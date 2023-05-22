/// Constructs and holds the checks required for a JWT to be considered valid.
/// Note that implementations are `not` thread-safe.
/// Once built by calling [Verification.build], the resulting
/// [JWTVerifier] is thread-safe.
///
abstract class Verification {
  /// Verifies whether the JWT contains an Issuer ("iss") claim
  /// that equals to the value provided.
  /// This check is case-sensitive.
  Verification withSingleIssuer(String issuer) =>
    withIssuer(<String>[issuer]);

  /// Verifies whether the JWT contains an Issuer ("iss") claim
  /// that contains all the values provided.
  /// This check is case-sensitive.
  /// An empty array is considered as a `null`.
  Verification withIssuer(List<String> issuer);

  /// Verifies whether the JWT contains a Subject ("sub") claim
  /// that equals to the value provided.
  /// This check is case-sensitive.
  Verification withSubject(String subject);

  /// Verifies whether the JWT contains an Audience ("aud") claim
  /// that contains all the values provided.
  /// This check is case-sensitive.
  /// An empty array is considered as a `null`.
  Verification withAudience(List<String> audience);

  /// Verifies whether the JWT contains an Audience ("aud") claim
  /// contain at least one of the specified audiences.
  /// This check is case-sensitive.
  /// An empty array is considered as a `null`.
  Verification withAnyOfAudience(List<String> audience);

  /// Define the default window in seconds in which the Not Before,
  /// Issued At and Expires At Claims will still be valid.
  /// Setting a specific leeway value on a given Claim
  /// will override this value for that Claim.
  /// Throws [ArgumentError] if leeway is negative.
  Verification acceptLeeway(int leeway);

  /// Set a specific leeway window in seconds in which
  /// the Expires At ("exp") Claim will still be valid.
  /// Expiration Date is always verified when the value is present.
  /// This method overrides the value set with acceptLeeway
  /// Throws [ArgumentError] if leeway is negative.
  Verification acceptExpiresAt(int leeway);

  /// Set a specific leeway window in seconds in which
  /// the Not Before ("nbf") Claim will still be valid.
  /// Not Before Date is always verified when the value is present.
  /// This method overrides the value set with acceptLeeway
  /// Throws [ArgumentError] if leeway is negative.
  Verification acceptNotBefore(int leeway);

  /// Set a specific leeway window in seconds in which
  /// the Issued At ("iat") Claim will still be valid.
  /// This method overrides the value set with [Verification.acceptLeeway].
  /// By default, the Issued At claim is always verified when
  /// the value is present, unless disabled with [Verification.ignoreIssuedAt].
  /// If Issued At verification has been disabled, no verification of
  /// the Issued At claim will be performed, and this method has no effect.
  /// Throws [ArgumentError] if leeway is negative.
  Verification acceptIssuedAt(int leeway);

  /// Verifies whether the JWT contains a JWT ID ("jti") claim
  /// that equals to the value provided.
  /// This check is case-sensitive.
  Verification withJWTId(String jwtId);

  /// Verifies whether the claim is present in the JWT, with any value
  /// including `null`.
  /// Throws [ArgumentError] if the name is `null`.
  Verification withClaimPresence(String name);

  /// Verifies whether the claim is present with a `null` value.
  /// Throws [ArgumentError] if the name is `null`.
  Verification withNullClaim(String name);

  /// Verifies whether the claim is equal to the given Boolean value.
  /// Throws [ArgumentError] if the name is `null`.
  Verification withClaim(String name, bool value);

  // TODO falta continuar
}