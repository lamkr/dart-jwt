import 'package:dart_jwt/jwt/header_params.dart';

import '../interfaces/header.dart';

// Implements the [Header] interface.
class BasicHeader implements Header {
  final String _algorithm;
  final String _type;
  final String _contentType;
  final String _keyId;
  final Map<String, dynamic> _tree;

  BasicHeader(
    this._algorithm,
    this._type,
    this._contentType,
    this._keyId,
    this._tree,
  );

  @override
  bool get isValid => true;

  @override
  bool get isNotValid => !isValid;

  @override
  String get algorithm => _algorithm;

  @override
  String get contentType => _contentType;

  @override
  dynamic headerClaim(String name) => _tree[name];

  @override
  String get keyId => _keyId;

  @override
  String get type => _type;

  factory BasicHeader.fromJson(Map<String, dynamic> json) {
    //return _$BasicHeaderFromJson(json);
    final algorithm = json[HeaderParams.algorithm] ?? '';
    final type = json[HeaderParams.type] ?? '';
    final contentType = json[HeaderParams.contentType] ?? '';
    final keyId = json[HeaderParams.keyId] ?? '';
    //jsonToDateTime(json['dataRecebimento']),
    //Double.tryParse(json['latitudeInicio'], latitudeInvalida),
    return BasicHeader(algorithm, type, contentType, keyId, json);
  }

  /// Connect the generated [_$JWTDecoderToJson] function
  /// to the `toJson` method.
  Map<String, dynamic> toJson() {
    // TODO: implement
    return {};
    //return _$JWTDecoderToJson(this);
  }
}
