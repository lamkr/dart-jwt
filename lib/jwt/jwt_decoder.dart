import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_jwt/exceptions/jwt_decode_exception.dart';
import 'package:json_annotation/json_annotation.dart';
import '../impl.dart';
import '../interfaces/decoded_jwt.dart';
import '../interfaces/header.dart';
import '../interfaces/jwt_parts_parser.dart';
import '../interfaces/payload.dart';
import 'token_utils.dart';

//part 'jwt_decoder.g.dart';

/// The JWTDecoder class holds the decode method to parse
/// a given JWT token into it's JWT representation.
///
/// This class is thread-safe.
@JsonSerializable()
class JWTDecoder implements DecodedJWT
{
  late final List<String> _parts;
  late final Header _header;
  late final Payload _payload;

  JWTDecoder(String jwt, {JWTPartsParser parser=const JWTParser()}) {
    _parts = TokenUtils.splitToken(jwt);
    late final Uint8List headerBytes;
    late final String headerJson;
    late final Uint8List payloadBytes;
    late final String payloadJson;
    try {
      headerBytes = base64.decode(_parts[0]);
      headerJson = String.fromCharCodes(headerBytes);
      payloadBytes = base64.decode(_parts[1]);
      payloadJson = String.fromCharCodes(payloadBytes);
    }
    catch(e) {
      throw JWTDecodeException(
          "The input is not a valid base 64 encoded string.",
          e as Exception?);
    }
    _header = parser.parseHeader(headerJson);
    _payload = parser.parsePayload(payloadJson);
  }

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  String get algorithm => _header.algorithm;

  @override
  String get contentType => _header.contentType;

  @override
  dynamic headerClaim(String name) =>
    _header.headerClaim(name);

  @override
  String get keyId => _header.keyId;

  @override
  String get type => _header.type;

  @override
  List<String> get audience => _payload.audience;

  @override
  dynamic claim(String name) => _payload.claim(name);

  @override
  Map<String, dynamic> get claims => _payload.claims;

  @override
  DateTime get expiresAt => _payload.expiresAt;

  @override
  String get subject => _payload.subject;

  @override
  String get id => _payload.id;

  @override
  DateTime get issuedAt => _payload.issuedAt;

  @override
  String get issuer => _payload.issuer;

  @override
  DateTime get notBefore => _payload.notBefore;

  @override
  String get header => _parts[0];

  @override
  String get payload => _parts[1];

  @override
  String get signature => _parts[2];

  @override
  String get token => '${_parts[0]}.${_parts[1]}.${_parts[2]}';

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

}