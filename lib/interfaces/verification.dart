import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/interfaces.dart';

/// Constructs and holds the checks required for a JWT to be considered valid.
/// Note that implementations are `not` thread-safe.
/// Once built by calling [Verification.build], the resulting
/// [JWTVerifier] is thread-safe.
abstract class Verification implements NullSafetyObject {

  static const invalid = _InvalidVerification();

  const Verification();

  @override
  bool get isValid => true;

  @override
  bool get isNotValid => !isValid;

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
  Verification withClaimPresence(String name);

  /// Verifies whether the claim is present with a `null` value.
  Verification withNullClaim(String name);

  /// Verifies whether the claim is equal to the given [T] value.
  /// [T] must be a comparable object.
  Verification withClaim<T>(String name, T value) {
    if(value is bool) {
      return withBoolClaim(name, value);
    } else if(value is int) {
      return withIntClaim(name, value);
    } else if(value is double) {
      return withDoubleClaim(name, value);
    } else if(value is String) {
      return withStringClaim(name, value);
    } else if(value is DateTime) {
      return withDateTimeClaim(name, value);
    } else {
      throw ArgumentError('Argument type not implemented');
    }
  }

  Verification withBoolClaim(String name, bool value);

  Verification withIntClaim(String name, int value);

  Verification withDoubleClaim(String name, double value);

  Verification withStringClaim(String name, String value);

  Verification withDateTimeClaim(String name, DateTime value);

  /// Executes the predicate provided and the validates the JWT
  /// if the predicate returns true.
  Verification withClaimPredicate(String name, BiPredicate<Claim, DecodedJWT> predicate);

  /// Verifies whether the claim contain at least the given [T] items.
  /// [T] must be a comparable object.
  Verification withArrayClaim<T>(String name, List<T> items);

  /// Skip the Issued At ("iat") claim verification.
  /// By default, the verification is performed.
  Verification ignoreIssuedAt();

  /// Creates a new and reusable instance of the [JWTVerifier]
  /// with the configuration already provided.
  JWTVerifier build();
}

class _InvalidVerification extends Verification {
  const _InvalidVerification() : super();

  @override
  bool get isValid => false;

  @override
  Verification acceptExpiresAt(int leeway) =>
    throw InvalidObjectException(runtimeType);

  @override
  Verification acceptIssuedAt(int leeway) =>
    throw InvalidObjectException(runtimeType);

  @override
  Verification acceptLeeway(int leeway) =>
    throw InvalidObjectException(runtimeType);

  @override
  Verification acceptNotBefore(int leeway) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withAnyOfAudience(List<String> audience) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withAudience(List<String> audience) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withClaim<T>(String name, T value) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withBoolClaim(String name, bool value) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withIntClaim(String name, int value) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withDoubleClaim(String name, double value) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withStringClaim(String name, String value) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withDateTimeClaim(String name, DateTime value) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withClaimPresence(String name) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withIssuer(List<String> issuer) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withJWTId(String jwtId) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withNullClaim(String name) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withSingleIssuer(String issuer) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withSubject(String subject) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification withClaimPredicate(String name, BiPredicate<Claim, DecodedJWT> predicate)
    => throw InvalidObjectException(runtimeType);

  @override
  Verification withArrayClaim<T>(String name, List<T> items) =>
      throw InvalidObjectException(runtimeType);

  @override
  Verification ignoreIssuedAt() =>
      throw InvalidObjectException(runtimeType);

  @override
  JWTVerifier build() =>
      throw InvalidObjectException(runtimeType);
}