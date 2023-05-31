/// The [DynamicClaim] retrieves a claim value from a [dynamic] object.
///
/// Note: this implementation is a replacement of
/// `JsonNodeClaim` in Java library.
import 'dart:convert';
import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/interfaces.dart';

class DynamicClaim implements Claim
{
  final dynamic _data;

  const DynamicClaim(this._data);

  @override
  dynamic get data => _data;

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => true;

  @override
  bool get isMissing => false;

  @override
  bool get isNull => !isMissing && data == null;

  @override
  String toString() {
    if (isMissing) {
      return "Missing claim";
    } else if (isNull) {
      return "Null claim";
    }
    else if (data is JsonSerializable) {
      return jsonEncode(data.toJson());
    }
    return data.toString();
  }

  @override
  bool? asBoolean() {
    return isMissing || isNull || data is! bool
        ? null : data as bool;
  }

  @override
  int? asInt() {
    return isMissing || isNull || data is! num
        ? null : (data is double ? (data as double).toInt() : data as int);
  }

  @override
  double? asDouble() {
    return isMissing || isNull || data is! num
        ? null : (data is int ? (data as int).toDouble() : data as double);
  }

  @override
  String? asString() {
    return isMissing || isNull || data is! String
        ? null : data as String;
  }

  @override
  DateTime? asDateTime() {
    if( isMissing || isNull || data is! int) {
      return null;
    }
    if( data is int) {
      return DateTime.fromMillisecondsSinceEpoch(data * 1000);
    }
    else if( data is DateTime ) {
      return data as DateTime;
    }
    return null;
  }

  @override
  List<T>? asList<T>() {
    if( isMissing || isNull || data is! List) {
      return null;
    }
    try {
      final list = <T>[];
      for( var elem in data ) {
        list.add(elem);
      }
      return list;
    }
    on Error catch(error) {
      throw JWTDecodeException.withError(
          "Couldn't map the Claim's list contents to ${T.runtimeType}"
          , error);
    }
    catch(e) {
      throw JWTDecodeException(
          "Couldn't map the Claim's list contents to ${T.runtimeType}"
          , e as Exception?);
    }
  }

  @override
  Map<String, V>? asMap<V>() {
    if( isMissing || isNull || data is! Map) {
      return null;
    }
    try {
      final dataMap = data as Map;
      final map = <String, V>{};
      for( var entry in dataMap.entries) {
        map[entry.key] = entry.value;
      }
      return map;
    }
    on Error catch(error) {
      throw JWTDecodeException.withError("Couldn't map the Claim value to Map",
          error);
    }
    catch(e) {
      throw JWTDecodeException("Couldn't map the Claim value to Map",
          e as Exception?);
    }
  }

  @override
  T? as<T>() {
    if( isMissing || isNull) {
      return null;
    }
    try {
      return data as T;
    }
    on Error catch(error) {
      throw JWTDecodeException.withError(
          "Couldn't map the Claim value to ${T.runtimeType}", error);
    }
    catch(e) {
      throw JWTDecodeException(
          "Couldn't map the Claim value to ${T.runtimeType}",
            e as Exception?);
    }
  }
}
