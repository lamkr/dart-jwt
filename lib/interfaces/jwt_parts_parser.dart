import 'header.dart';
import 'payload.dart';

/// The JWTPartsParser class defines which parts
/// of the JWT should be converted to its specific
/// [Object] representation instance.
abstract class JWTPartsParser {

  /// Parses the given [json] into a [Payload] instance.
  Payload parsePayload(String json);

  /// Parses the given [json] into a [Header] instance.
  Header parseHeader(String json);
}