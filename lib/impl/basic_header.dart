import 'package:dart_jwt/jwt/header_params.dart';
import 'package:intl/intl.dart';

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
    return BasicHeader(algorithm, type, contentType, keyId, claims);
  }

  static Map<String, Claim> _claimsFromJson(Map<String, dynamic> json) {
    final claims = <String, Claim>{};
    for(var entry in json.entries) {
      final claim = DynamicClaim(entry.value);
      claims[entry.key] = claim;
    }
    return claims;
  }

  /// Connect the generated [_$JWTDecoderToJson] function
  /// to the `toJson` method.
  @override
  Map<String, dynamic> toJson() {
    //return _$JWTDecoderToJson(this);
    var json = <String, dynamic>{};
    if( _algorithm.isNotEmpty ) {
      json[HeaderParams.algorithm] = _algorithm;
    }
    if( _type.isNotEmpty ) {
      json[HeaderParams.type] = _type;
    }
    if( _contentType.isNotEmpty ) {
      json[HeaderParams.contentType] = _contentType;
    }
    if( _keyId.isNotEmpty ) {
      json[HeaderParams.keyId] = _keyId;
    }
    json = _claimsToJson(json);
    return json;
  }

  Map<String, dynamic> _claimsToJson(Map<String, dynamic> json) {
    for(var entry in _tree.entries) {
      final claim = entry.value;
      if( claim.isValid && !claim.isMissing ) {
        json[entry.key] = claim.data;
      }
    }
    return json;
  }

}
