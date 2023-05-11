import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

void main() {
  test('getSubject', () {
    DecodedJWT jwt = JWT.decode(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ');
    expect(jwt.getSubject(), isNotEmpty);
    expect(jwt.getSubject(), '1234567890');
  });
}
