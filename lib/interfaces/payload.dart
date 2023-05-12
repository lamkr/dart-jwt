import 'package:dart_jwt/null_safety_object.dart';

/// The Payload class represents the 2nd part of the JWT,
/// where the Payload value is held.
abstract class Payload implements NullSafetyObject {

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

  /// Get a Claim given its name. If the Claim wasn't specified in the Payload,
  /// a 'empty claim' will be returned. All the methods of that claim will
  /// return `null`.
  dynamic /*Claim*/ claim(String name);

  /// Get an non-null Map containing the Claims defined in the Token.
  Map<String, dynamic /*Claim*/> get claims;
}