import 'package:dart_jwt/algorithms.dart';
import 'package:dart_jwt/exceptions.dart';

class SignatureGenerationException extends Throwable {
  SignatureGenerationException(Algorithm algorithm, [Exception? cause])
      : super(
            "The Token's Signature couldn't be generated when signing using the Algorithm: $algorithm",
            cause);

  SignatureGenerationException.withError(Algorithm algorithm, Error error)
      : super.withError(
          "The Token's Signature couldn't be generated when signing using the Algorithm: $algorithm",
          error,
        );
}
