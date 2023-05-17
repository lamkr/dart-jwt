abstract class Throwable implements Exception {
  final dynamic message;
  final Exception? cause;

  Throwable([this.message, this.cause]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Throwable";
    return "Throwable: $message";
  }
}
