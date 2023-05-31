import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main() {
  PayloadDeserializer deserializer = BasicPayloadDeserializer();

  test('shouldNotRemoveKnownPublicClaimsFromTree', () {
    const payloadJson = '''
    { 
      "iss": "auth0",
      "sub": "emails",
      "aud": "users",
      "iat": 10101010,
      "exp": 11111111,
      "nbf": 10101011,
      "jti": "idid",
      "roles": "admin"
    }''';

    final payload = deserializer.deserialize(payloadJson);

    expect(payload, isNotNull);
    expect(payload.issuer, "auth0");
    expect(payload.subject, "emails");
    expect(payload.audience, containsAll(['users']));
    expect(payload.issuedAt.millisecondsSinceEpoch, 10101010 * 1000);
    expect(payload.expiresAt.millisecondsSinceEpoch, 11111111 * 1000);
    expect(payload.notBefore.millisecondsSinceEpoch, 10101011 * 1000);
    expect(payload.id, "idid");

    expect(payload.claim("roles").asString(), "admin");
    expect(payload.claim("iss").asString(), "auth0");
    expect(payload.claim("sub").asString(), "emails");
    expect(payload.claim("aud").asString(), "users");
    expect(payload.claim("iat").asDouble(), 10101010.0);
    expect(payload.claim("exp").asDouble(), 11111111.0);
    expect(payload.claim("nbf").asDouble(), 10101011.0);
    expect(payload.claim("jti").asString(), "idid");

  });
}