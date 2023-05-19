import 'package:dart_jwt/exceptions/invalid_object_exception.dart';
import 'package:dart_jwt/ext/null_safety_object.dart';

import 'claim.dart';

abstract class Header implements NullSafetyObject
{
  static const Header invalid = _InvalidHeader();

  const Header();

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

  /// Get a private [Claim] given it's [name].
  /// If the claim wasn't specified in the [Header],
  /// a invalid claim will be returned (see [Claim.invalid]).
  /// All the methods of that claim will throw [InvalidObjectException].
  Claim headerClaim(String name);

  Map<String, dynamic> toJson();
}

class _InvalidHeader extends Header {

  const _InvalidHeader();

  @override
  bool get isValid => false;

  @override
  bool get isNotValid => !isValid;

  @override
  String get algorithm => '';

  @override
  String get contentType => '';

  @override
  Claim headerClaim(String name) => Claim.invalid;

  @override
  String get keyId => '';

  @override
  String get type => '';

  @override
  Map<String, dynamic> toJson() =>
      throw InvalidObjectException(runtimeType);
}