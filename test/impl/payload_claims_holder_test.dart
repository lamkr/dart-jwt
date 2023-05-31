import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main() {

  test('shouldGetClaims', () {
    final claims = <String, Claim>{
      "iss": DynamicClaim("auth0"),
    };
    final holder = PayloadClaimsHolder(claims);
    expect( holder.claims, isNotNull);
    expect( holder.claims, isA<Map<String,Claim>>());
  });

  test('shouldGetNotNullClaims', () {
    final holder = PayloadClaimsHolder();
    expect( holder.claims, isNotNull);
    expect( holder.claims, isA<Map<String,Claim>>());
  });
}
