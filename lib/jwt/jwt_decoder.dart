import 'package:json_annotation/json_annotation.dart';
import '../impl.dart';
import '../interfaces/decoded_jwt.dart';

//part 'jwt_decoder.g.dart';

/// The JWTDecoder class holds the decode method to parse
/// a given JWT token into it's JWT representation.
///
/// This class is thread-safe.
@JsonSerializable()
class JWTDecoder implements DecodedJWT
{
  JWTDecoder(String jwt)
    : this.withParser(JWTParser(), jwt);

  JWTDecoder.withParser(JWTParser parser, String jwt) {
    throw UnimplementedError();
  }

  factory JWTDecoder.fromJson(Map<String, dynamic> json) {
    //return _$JWTDecoderFromJson(json);
    // TODO: implement
    return JWTDecoder('');
  }

  /// Connect the generated [_$JWTDecoderToJson] function
  /// to the `toJson` method.
  Map<String, dynamic> toJson() {
    // TODO: implement
    return {};
    //return _$JWTDecoderToJson(this);
  }

  @override
  String getSubject() {
    // TODO: implement getSubject
    throw UnimplementedError();
  }

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;
}