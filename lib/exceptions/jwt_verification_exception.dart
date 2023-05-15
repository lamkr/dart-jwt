/// Parent to all the exception thrown while verifying a JWT.
class JWTVerificationException implements Exception {

  final Exception? cause;
  final String message;

  JWTVerificationException(this.message, [this.cause]);

  @override
  String toString() {
    if (message.isEmpty) {
      return runtimeType.toString();
    }
    return message;
  }
}
