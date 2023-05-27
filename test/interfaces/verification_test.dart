import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main() {
  test('With issuer string default impl should delegate', () {
    final Verification verification = VerificationImplForTest()
        .withSingleIssuer('string');

    expect(verification, isA<VerificationImplForTest>() );
    expect((verification as VerificationImplForTest).expectedClaims,
      containsPair('iss', <String>['string']));
  });

}

class VerificationImplForTest implements Verification {

  final expectedClaims = <String, dynamic>{};

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => true;

  @override
  Verification withClaim<T>(String name, T value) {
    return Verification.invalid;
  }

  @override
  Verification withIssuer(List<String> issuer) {
    expectedClaims["iss"] = issuer;
    return this;
  }

  @override
  Verification withSingleIssuer(String issuer) {
    return withIssuer([issuer]);
  }

  @override
  Verification withSubject(String subject) => Verification.invalid;
  
  @override
  Verification withAudience(List<String> audience) => Verification.invalid;
  
  @override
  Verification withAnyOfAudience(List<String> audience) => Verification.invalid;
  
  @override
  Verification acceptLeeway(int leeway) => Verification.invalid;
  
  @override
  Verification acceptExpiresAt(int leeway) => Verification.invalid;
  
  @override
  Verification acceptNotBefore(int leeway) => Verification.invalid;
  
  @override
  Verification acceptIssuedAt(int leeway) => Verification.invalid;
  
  @override
  Verification withJWTId(String jwtId) => Verification.invalid;
  
  @override
  Verification withClaimPresence(String name) => Verification.invalid;
  
  @override
  Verification withNullClaim(String name) => Verification.invalid;
  
  @override
  Verification withArrayClaim<T>(String name, List<T> items) => Verification.invalid;
  
  @override
  Verification withClaimPredicate(String name, BiPredicate<Claim, DecodedJWT> predicate) => Verification.invalid;
  
  @override
  Verification ignoreIssuedAt() => Verification.invalid;
  
  @override
  JWTVerifier build() {
    return JWTVerifier.invalid;
  }

  @override
  Verification withBoolClaim(String name, bool value) => Verification.invalid;

  @override
  Verification withDateTimeClaim(String name, DateTime value) => Verification.invalid;

  @override
  Verification withDoubleClaim(String name, double value) => Verification.invalid;

  @override
  Verification withIntClaim(String name, int value) => Verification.invalid;

  @override
  Verification withStringClaim(String name, String value) => Verification.invalid;
}
