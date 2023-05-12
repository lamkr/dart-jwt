import 'jwt_verification_exception.dart';

/// The exception that is thrown when any part
/// of the token contained an invalid JWT or JSON format.
class JWTDecodeException extends JWTVerificationException {

  JWTDecodeException(String message) : super(message);
}
