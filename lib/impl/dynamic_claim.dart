/// The [DynamicClaim] retrieves a claim value from a [dynamic] object.
///
/// Note: this implementation is a replacement of
/// `JsonNodeClaim` in Java library.
import '../exceptions/jwt_decode_exception.dart';
import '../interfaces/claim.dart';

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
    return data.toString();
  }

  @override
  bool? asBoolean() {
    return isMissing || isNull || data is! bool
        ? null : data as bool;
  }

  @override
  int? asInt() {
    return isMissing || isNull || data is! int
        ? null : data as int;
  }

  @override
  double? asDouble() {
    return isMissing || isNull || data is! double
        ? null : data as double;
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
      return List.castFrom<dynamic, T>(data);
    }
    on Exception catch(e) {
      throw JWTDecodeException("Couldn't map the Claim's array contents to ${T.runtimeType}"
          , e);
    }
  }

  @override
  Map<String, V>? asMap<V>() {
    if( isMissing || isNull || data is! Map) {
      return null;
    }
    try {
      return Map.castFrom<dynamic, dynamic, String, V>(data);
    }
    on Exception catch(e) {
      throw JWTDecodeException("Couldn't map the Claim value to Map", e);
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
    on Exception catch(e) {
      throw JWTDecodeException("Couldn't map the Claim value to ${T.runtimeType}", e);
    }
  }
}
