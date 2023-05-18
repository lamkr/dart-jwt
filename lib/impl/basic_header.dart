import 'package:dart_jwt/jwt/header_params.dart';

import '../interfaces/claim.dart';
import '../interfaces/header.dart';
import 'dynamic_claim.dart';

// Implements the [Header] interface.
class BasicHeader implements Header {
  final String _algorithm;
  final String _type;
  final String _contentType;
  final String _keyId;
  final Map<String, Claim> _tree;

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
  Claim headerClaim(String name) {
    if( _tree.containsKey(name) ) {
      return _tree[name] as Claim;
    }
    return Claim.invalid;
  }

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
    final claims = _claimsFromJson(json);
    //jsonToDateTime(json['dataRecebimento']),
    //Double.tryParse(json['latitudeInicio'], latitudeInvalida),
    return BasicHeader(algorithm, type, contentType, keyId, claims);
  }

  /// Connect the generated [_$JWTDecoderToJson] function
  /// to the `toJson` method.
  Map<String, dynamic> toJson() {
    // TODO: implement
    return {};
    //return _$JWTDecoderToJson(this);
  }

  static Map<String, Claim> _claimsFromJson(Map<String, dynamic> json) {
    final claims = <String, Claim>{};
    for(var entry in json.entries) {
      final claim = DynamicClaim(entry.value);
      claims[entry.key] = claim;
    }
    return claims;
  }

}
