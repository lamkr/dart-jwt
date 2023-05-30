import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';

/// The exception that is thrown if the Signature verification fails.
class SignatureVerificationException extends Throwable {
  SignatureVerificationException(Algorithm algorithm, [Exception? cause])
      : super(
            "The Token's Signature resulted invalid when verified using the Algorithm: $algorithm",
            cause);

  SignatureVerificationException.withError(Algorithm algorithm, Error error)
      : super.withError(
          "The Token's Signature resulted invalid when verified using the Algorithm: $algorithm",
          error,
        );
}
