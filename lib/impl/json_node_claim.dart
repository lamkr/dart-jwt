/// The [DynamicClaim] retrieves a claim value from a [dynamic] object.
///
/// Note: this implementation is a replacement of
/// `JsonNodeClaim` in Java library.
import '../interfaces/claim.dart';

class DynamicClaim implements Claim
{
  final dynamic data;

  DynamicClaim(this.data);

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => true;

  @override
  bool? asBoolean() {
    return isMissing() || isNull() || data !is bool
        ? null : data as bool;
  }

  @override
  int? asInt() {
    return isMissing() || isNull() || data !is int
        ? null : data as int;
  }

  @override
  double? asDouble() {
    return isMissing() || isNull() || data !is double
        ? null : data as double;
  }

  @override
  String? asString() {
    return isMissing() || isNull() || data !is String
        ? null : data as String;
  }

  @override
  DateTime? asDateTime() {
    if( isMissing() || isNull() || data !is int) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(data * 1000);
  }

  @override
  List<T> asList<T>() {
    // TODO: implement asList
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> asMap() {
    // TODO: implement asMap
    throw UnimplementedError();
  }

  @override
  bool isMissing() {
    // TODO: implement isMissing
    throw UnimplementedError();
  }

  @override
  bool isNull() {
    // TODO: implement isNull
    throw UnimplementedError();
  }

  @override
  T as<T>() {
    throw UnimplementedError();
  }
}
