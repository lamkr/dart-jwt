/// Parent to all the exception thrown while verifying a JWT.
class JWTVerificationException implements Exception {

  final String message;

  JWTVerificationException(this.message);

  @override
  String toString() {
    if (message.isEmpty) {
      return runtimeType.toString();
    }
    return message;
  }
}
