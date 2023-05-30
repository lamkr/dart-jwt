import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main() {

  HeaderDeserializer deserializer = BasicHeaderDeserializer();

  test('shouldNotRemoveKnownPublicClaimsFromTree', () {
    const headerJson = '''
    { 
      "alg": "HS256",
      "typ": "jws",
      "cty": "content",
      "kid": "key",
      "roles": "admin"
    }''';

    final header = deserializer.deserialize(headerJson);
    
    expect(header, isNotNull);
    expect(header.algorithm, "HS256");
    expect(header.type, "jws");
    expect(header.contentType, "content");
    expect(header.keyId, "key");

    expect(header.headerClaim("roles").asString(), "admin");
    expect(header.headerClaim("alg").asString(), "HS256");
    expect(header.headerClaim("typ").asString(), "jws");
    expect(header.headerClaim("cty").asString(), "content");
    expect(header.headerClaim("kid").asString(), "key");
  });
}
