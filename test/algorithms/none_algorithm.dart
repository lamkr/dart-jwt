import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/jwt.dart';
import 'package:test/test.dart';

void main() {
  test('Should pass none verification', () {
    Algorithm algorithm = Algorithm.none;
    const jwt = "eyJhbGciOiJub25lIiwiY3R5IjoiSldUIn0.eyJpc3MiOiJhdXRoMCJ9.";
    algorithm.verify(JWT.decode(jwt));
  });
}