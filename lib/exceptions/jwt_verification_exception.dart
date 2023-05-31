import 'package:dart_jwt/exceptions/throwable.dart';

/// Parent to all the exception thrown while verifying a JWT.
class JWTVerificationException extends Throwable {

  JWTVerificationException(dynamic message, [Exception? cause]):
      super(message, cause);

  JWTVerificationException.withError(dynamic message, Error error):
        super.withError(message, error);

  @override
  String toString() {
    if (message.isEmpty) {
      return runtimeType.toString();
    }
    return message;
  }
}
