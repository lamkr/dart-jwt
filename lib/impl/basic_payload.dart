import 'package:dart_jwt/interfaces.dart';

import '../exceptions/jwt_decode_exception.dart';
import '../ext/date_time_extension.dart';
import '../jwt/registered_claims.dart';

class BasicPayload implements Payload {
  final String _subject;
  final String _issuer;
  final List<String> _audience;
  final DateTime _expiresAt;
  final DateTime _notBefore;
  final DateTime _issuedAt;
  final String _id;
  final Map<String, dynamic> _tree;

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
    final expiresAt = jsonToDateTime(json[RegisteredClaims.expiresAt]);
    final notBefore = jsonToDateTime(json[RegisteredClaims.notBefore]);
    final issuedAt = jsonToDateTime(json[RegisteredClaims.issuedAt]);
    final id = _getString(json[RegisteredClaims.jwtId]);
    return BasicPayload(subject, issuer, audience, expiresAt, notBefore,
        issuedAt, id, json);
  }

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  List<String> get audience => _audience;

  @override
  dynamic claim(String name) => _tree[name];

  @override
  Map<String, dynamic> get claims => _tree;

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
      return audience as List<String>;
    }
    else if( audience is String ) {
      return <String>[audience];
    }
    throw JWTDecodeException("Couldn't map the Claim's array contents to String");
  }

  static String _getString(dynamic json) {
    if (json == null) {
      return '';
    }
    return json! is String ? json.toString() : json;
  }

  Map<String, dynamic> toJson() {
    // TODO: implement
    throw UnimplementedError();
  }
}
