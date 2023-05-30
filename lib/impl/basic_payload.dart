import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/jwt.dart';

class BasicPayload implements Payload {
  final String _subject;
  final String _issuer;
  final List<String> _audience;
  final DateTime _expiresAt;
  final DateTime _notBefore;
  final DateTime _issuedAt;
  final String _id;
  final Map<String, Claim> _tree;

  BasicPayload(
    this._subject,
    this._issuer,
    this._audience,
    this._expiresAt,
    this._notBefore,
    this._issuedAt,
    this._id,
    this._tree,
  );

  factory BasicPayload.fromJson(Map<String, dynamic> json) {
    final subject = _getString(json[RegisteredClaims.subject]);
    final issuer = _getString(json[RegisteredClaims.issuer]);
    final audience = _audienceFromJson(json);
    final expiresAt = dateTimeFromSeconds(json[RegisteredClaims.expiresAt]);
    final notBefore = dateTimeFromSeconds(json[RegisteredClaims.notBefore]);
    final issuedAt = dateTimeFromSeconds(json[RegisteredClaims.issuedAt]);
    final id = _getString(json[RegisteredClaims.jwtId]);
    final tree = _claimsFromJson(json);
    return BasicPayload(subject, issuer, audience, expiresAt, notBefore,
        issuedAt, id, tree);
  }

  @override
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};
    if( _subject.isNotEmpty ) {
      json[RegisteredClaims.subject] = _subject;
    }
    if( _issuer.isNotEmpty ) {
      json[RegisteredClaims.issuer] = _issuer;
    }
    if( _audience.isNotEmpty ) {
      json[RegisteredClaims.audience] = _audience;
    }
    if( _expiresAt.isValid ) {
      json[RegisteredClaims.expiresAt] = _expiresAt.millisecondsSinceEpoch * 1000;
    }
    if( _notBefore.isValid ) {
      json[RegisteredClaims.notBefore] = _notBefore.millisecondsSinceEpoch * 1000;
    }
    if( _issuedAt.isValid ) {
      json[RegisteredClaims.issuedAt] = _issuedAt.millisecondsSinceEpoch * 1000;
    }
    if( _id.isNotEmpty ) {
      json[RegisteredClaims.jwtId] = _id;
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

  @override
  bool get isValid => true;

  @override
  bool get isNotValid => !isValid;

  @override
  List<String> get audience => _audience;

  @override
  Claim claim(String name) {
    if(_tree.containsKey(name)) {
      return _tree[name] as Claim;
    }
    return Claim.missing;
  }

  @override
  Map<String, Claim> get claims => _tree;

  @override
  DateTime get expiresAt => _expiresAt;

  @override
  String get id => _id;

  @override
  DateTime get issuedAt => _issuedAt;

  @override
  String get issuer => _issuer;

  @override
  DateTime get notBefore => _notBefore;

  @override
  String get subject => _subject;

  static List<String> _audienceFromJson(Map<String, dynamic> json) {
    final audience = json[RegisteredClaims.audience];
    if( audience == null ) {
      return <String>[];
    }
    if( audience is List ) {
      return List.castFrom<dynamic,String>(audience);
    }
    else if( audience is String ) {
      return <String>[audience];
    }
    throw JWTDecodeException("Couldn't map the Claim's array contents to String");
  }

  static String _getString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value is! String ? value.toString() : value;
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
