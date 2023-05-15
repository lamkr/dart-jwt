import 'package:dart_jwt/ext/null_safety_object.dart';

abstract class Header implements NullSafetyObject
{
  /// Getter for the Algorithm "alg" claim defined in the JWT's Header.
  /// If the claim is missing it will return empty.
  String get algorithm;

  /// Getter for the Type "typ" claim defined in the JWT's Header.
  /// If the claim is missing it will return empty.
  String get type;

  /// Getter for the Content Type "cty" claim defined in the JWT's
  /// Header. If the claim is missing it will return empty.
  String get contentType;

  /// Get the value of the "kid" claim, or empty if it's not available.
  String get keyId;

  /// Get a private claim given it's [name]. If the claim wasn't
  /// specified in the header, a null claim will be
  /// returned. All the methods of that claim will return empty.
  dynamic headerClaim(String name);
}