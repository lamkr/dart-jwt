import '../exceptions/jwt_decode_exception.dart';

abstract class TokenUtils
{
    /// Splits the given token on the "." chars into a
    /// String array with 3 parts.
    /// Throws [JWTDecodeException] if the [token] doesn't have 3 parts.
    static List<String> splitToken(String token) {
        if (token.isEmpty) {
            throw JWTDecodeException('The token is empty.');
        }

        final delimiter = '.';
        final parts = token.split(delimiter);

        if(parts.length != 3) {
            throw _wrongNumberOfParts(parts.length);
        }

        return parts;
    }

    static JWTDecodeException _wrongNumberOfParts(int partCount) {
        return JWTDecodeException(
            "The token was expected to have 3 parts, but got ${partCount > 3 ? "> 3" : partCount}.");
    }
}
