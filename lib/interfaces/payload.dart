import 'package:dart_jwt/ext/date_time_extension.dart';
import 'package:dart_jwt/ext/null_safety_object.dart';
import 'package:dart_jwt/ext/json_serializable.dart';

import '../exceptions/invalid_object_exception.dart';
import 'claim.dart';

/// The Payload class represents the 2nd part of the JWT,
/// where the Payload value is held.
abstract class Payload implements NullSafetyObject, JsonSerializable {

  static const Payload invalid = _InvalidPayload();

  const Payload();

  /// Get the value of the "sub" claim (Subject), or empty if it's not available.
  String get subject;

  /// Get the value of the "iss" claim (Issuer), or empty if it's not available.
  String get issuer;

  /// Get the value of the "aud" claim (Audience), or empty if it's not available.
  List<String> get audience;

  /// Get the value of the "exp" claim (Expiration Time), or null if it's not available.
  DateTime get expiresAt;

  /// Get the value of the "nbf" claim (Not Before), or null if it's not available.
  DateTime get notBefore;

  /// Get the value of the "iat" claim (Issued At), or null if it's not available.
  DateTime get issuedAt;

  /// Get the value of the "jti" claim (JWT ID), or null if it's not available.
  String get id;

  /// Get a [Claim] given its [name].
  /// If the claim wasn't specified in the [Payload],
  /// a invalid claim will be returned (see [Claim.invalid]).
  /// All the methods of that claim will throw [InvalidObjectException].
  Claim claim(String name);

  /// Get an non-null [Map] containing the claims defined in the token.
  Map<String, Claim> get claims;

  @override
  Map<String, dynamic> toJson();
}

class _InvalidPayload extends Payload {

  const _InvalidPayload();

  @override
  bool get isValid => false;

  @override
  bool get isNotValid => !isValid;

  @override
  List<String> get audience => [];

  @override
  Claim claim(String name) => Claim.invalid;

  @override
  Map<String, Claim> get claims => {};

  @override
  DateTime get expiresAt => invalidDateTime;

  @override
  String get id => '';

  @override
  DateTime get issuedAt => invalidDateTime;

  @override
  String get issuer => '';

  @override
  DateTime get notBefore => invalidDateTime;

  @override
  String get subject => '';

  @override
  Map<String, dynamic> toJson() =>
      throw InvalidObjectException(runtimeType);
}