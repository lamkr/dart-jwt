abstract class Throwable implements Exception {
  final dynamic message;
  final Exception? cause;
  final Error? error;

  Throwable([this.message, this.cause]) :
    error = null;

  Throwable.withError([this.message, this.error]) :
      cause = null;

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Throwable";
    return "Throwable: $message";
  }
}