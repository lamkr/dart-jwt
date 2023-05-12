import '../exceptions/jwt_decode_exception.dart';
import '../interfaces/header.dart';
import '../interfaces/header_deserializer.dart';
import '../interfaces/jwt_parts_parser.dart';
import '../interfaces/payload.dart';
import 'basic_header_deserializer.dart';

/// This class helps in decoding the Header and Payload
/// of the JWT using {HeaderSerializer} and {PayloadSerializer}.
class JWTParser implements JWTPartsParser {

  final HeaderDeserializer _headerDeserializer;

  JWTParser([this._headerDeserializer=const BasicHeaderDeserializer()]);

  @override
  Header parseHeader(String json) {
    if (json.isEmpty) {
      throw _decodeException(json);
    }

    try {
      return _headerDeserializer.deserialize(json);
    }
    catch (_) {
      throw _decodeException(json);
    }
  }

  @override
  Payload parsePayload(String json) {
    // TODO: implement parsePayload
    throw UnimplementedError();
  }

  static JWTDecodeException _decodeException(String json) {
    return JWTDecodeException('The string $json doesn\'t have a valid JSON format.');
  }
}