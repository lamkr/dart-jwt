import 'package:dart_jwt/ext/null_safety_object.dart';
import 'package:dart_jwt/extensions.dart';
import '../exceptions/invalid_object_exception.dart';

/// The Claim class holds the value in a generic way
/// so that it can be recovered in many representations.
abstract class Claim implements NullSafetyObject
{
  static const Claim invalid = _InvalidClaim();

  static const Claim missing = _MissingClaim();

  static const Claim nullClaim = _NullClaim();

  const Claim();

  @override
  bool get isValid => true;

  @override
  bool get isNotValid => !isValid;

  dynamic get data;

  /// Whether this Claim has a null value or not.
  /// If the claim is not present, it will return false hence checking {@link Claim#isMissing} is advised as well
  /// Return whether this Claim has a null value or not.
  bool get isNull;

  /// Can be used to verify whether the Claim is found or not.
  /// This will be true even if the Claim has {@code null} value associated to it.
  /// Return whether this Claim is present or not
  bool get isMissing;

  /// Get this Claim as a bool.
  /// If the value isn't of type [bool] or it can't be converted to a [bool], {@code null} will be returned.
  /// Return the value as a Boolean or null.
  bool? asBoolean();

  /// Get this Claim as an [int].
  /// If the value isn't of type [int] or it can't be converted to an [int], {@code null} will be returned.
  /// Return the value as an [int] or null.
  int? asInt();

  /// Get this Claim as a [double].
  /// If the value isn't of type [double] or it can't be converted to a [double], {@code null} will be returned.
  /// Return the value as a [double] or null.
  double? asDouble();

  /// Get this Claim as a [String].
  /// If the value isn't of type [String], {@code null} will be returned.
  /// For a [String] representation of non-textual claim types, clients
  /// can call {@code toString()}.
  /// Return the value as a [String] or null if the underlying value is
  /// not a string.
  String? asString();

  /// Get this Claim as a [DateTime].
  /// If the value can't be converted to a [DateTime], {@code null}
  /// will be returned.
  /// Return the value as a [DateTime] or null.
  DateTime? asDateTime();

  /// Get this Claim as an [List] of type T.
  /// If the value isn't an list, {@code null} will be returned.
  /// Throws [JWTDecodeException] if the values inside the list
  /// can't be converted to a class T.
  List<T>? asList<T>();

  /// Get this Claim as a generic [Map] of values.
  /// Throws [JWTDecodeException] if the value can't be converted
  /// to a Map.
  Map<String, V>? asMap<V>();

  /// Get this Claim as a custom type T.
  /// This method will return `null` if [Claim.isMissing()]
  /// or [Claim.isNull()] is true.
  /// Throws [JWTDecodeException] if the value can't be converted
  /// to a class T.
  T? as<T>();
}

class _InvalidClaim extends Claim {

  const _InvalidClaim();

  @override
  bool get isValid => false;

  @override
  dynamic get data => throw InvalidObjectException(runtimeType);

  @override
  T? as<T>() => throw InvalidObjectException(runtimeType);

  @override
  bool? asBoolean() =>
    throw InvalidObjectException(runtimeType);

  @override
  DateTime? asDateTime() =>
    throw InvalidObjectException(runtimeType);

  @override
  double? asDouble() =>
    throw InvalidObjectException(runtimeType);

  @override
  int? asInt() =>
    throw InvalidObjectException(runtimeType);

  @override
  List<T> asList<T>() =>
    throw InvalidObjectException(runtimeType);

  @override
  Map<String, V>? asMap<V>() =>
    throw InvalidObjectException(runtimeType);

  @override
  String? asString() =>
    throw InvalidObjectException(runtimeType);

  @override
  bool get isMissing =>
    throw InvalidObjectException(runtimeType);

  @override
  bool get isNull =>
    throw InvalidObjectException(runtimeType);

  @override
  String toString() => throw InvalidObjectException(runtimeType);
}

class _MissingClaim extends Claim {

  const _MissingClaim();

  @override
  bool get isValid => true;

  @override
  dynamic get data => null;

  @override
  T? as<T>() => data as T?;

  @override
  bool? asBoolean() => null;

  @override
  DateTime? asDateTime() => null;

  @override
  double? asDouble() => null;

  @override
  int? asInt() => null;

  @override
  List<T>? asList<T>() => null;

  @override
  Map<String, V>? asMap<V>() => null;

  @override
  String? asString() => null;

  @override
  bool get isMissing => true;

  @override
  bool get isNull => false;

  @override
  String toString() => 'Missing claim';
}

class _NullClaim extends Claim {

  const _NullClaim();

  @override
  bool get isValid => true;

  @override
  dynamic get data => null;

  @override
  T? as<T>() => data as T?;

  @override
  bool? asBoolean() => null;

  @override
  DateTime? asDateTime() => null;

  @override
  double? asDouble() => null;

  @override
  int? asInt() => null;

  @override
  List<T>? asList<T>() => null;

  @override
  Map<String, V>? asMap<V>() => null;

  @override
  String? asString() => null;

  @override
  bool get isMissing => false;

  @override
  bool get isNull => true;

  @override
  String toString() => 'Null claim';
}