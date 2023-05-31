import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

import '../lib/core_matchers.dart';

void main() {
  final DateTime expiresAt = DateTime.now().add(Duration(seconds: 10));
  final DateTime notBefore = DateTime.now();
  final DateTime issuedAt = DateTime.now();
  final BasicPayload payload = BasicPayload(
    "issuer",
    "subject",
    <String>["audience"],
    expiresAt,
    notBefore,
    issuedAt,
    "jwtId",
    <String, Claim>{"extraClaim": DynamicClaim("extraValue")},
  );

  test('shouldHaveUnmodifiableTree', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
    invalidDateTime, '', {} );
    expect(
        () => payload.tree["something"] = Claim.invalid, throwsUnsupportedError);
  });

  test('shouldHaveUnmodifiableAudience', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( () => payload.audience.add("something"), throwsUnsupportedError);
  });

  test('shouldGetIssuer', () {
    expect( payload.issuer, "issuer");
  });

  test('shouldGetNullIssuerIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.issuer, isEmpty);
  });

  test('shouldGetSubject', () {
    expect( payload.subject, "subject");
  });

  test('shouldGetNullSubjectIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.subject, isEmpty);
  });

  test('shouldGetAudience', () {
    expect( payload.audience, hasLength(1));
    expect( payload.audience, contains("audience"));
  });

  test('shouldGetNullAudienceIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.audience, isEmpty);
  });

  test('shouldGetExpiresAt', () {
    expect( payload.expiresAt, expiresAt);
  });

  test('shouldGetNullExpiresAtIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.expiresAt, isNotValidDateTime);
  });

  test('shouldGetNotBefore', () {
    expect( payload.notBefore, notBefore);
  });

  test('shouldGetNullNotBeforeIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.notBefore, isNotValidDateTime);
  });

  test('shouldGetIssuedAt', () {
    expect( payload.issuedAt, issuedAt);
  });

  test('shouldGetNullIssuedAtIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.issuedAt, isNotValidDateTime);
  });

  test('shouldGetJWTId', () {
    expect( payload.id, "jwtId");
  });

  test('shouldGetNullJWTIdIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.issuedAt, isEmpty);
  });

  test('shouldGetExtraClaim', () {
    expect( payload.claim("extraClaim"), isNotNull);
    expect( payload.claim("extraClaim"), "extraValue");
  });

  test('shouldGetNotNullExtraClaimIfMissing', () {
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', {} );
    expect( payload.claim("missing"), isNotNull);
    expect( payload.claim("missing").isMissing, isTrue);
    expect( payload.claim("missing").isNull, isFalse);
  });

  test('shouldGetClaims', () {
    final tree = <String, Claim>{
      "extraClaim": DynamicClaim("extraValue"),
      "sub": DynamicClaim("auth0")
    };
    final payload = BasicPayload('', '', [], invalidDateTime, invalidDateTime,
        invalidDateTime, '', tree );
    final claims = payload.claims;
    expect( claims, isNotNull);
    expect( claims["extraClaim"], isNotNull);
    expect( claims["sub"], isNotNull);
  });

  test('shouldGetNotNullExtraClaimIfMissing', () {
    final claims = payload.claims;
    expect( claims, isNotNull);
    expect( () => claims["name"] = Claim.invalid, throwsUnsupportedError);
  });
}
