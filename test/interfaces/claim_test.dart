import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main() {
  test('Should get instant using default', () {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(1646667492000);
    Claim claim = ClaimImplForTest(date);
    expect(claim.asDateTime(), date);
  });


  test('Should get null instant using default', () {
    Claim claim = ClaimImplForTest(null);
    expect(claim.asDateTime(), isNull);
  });
}

/// Implementation that does not override {@code asInstant()}
class ClaimImplForTest implements Claim {
  final DateTime? date;

  ClaimImplForTest(this.date);

  @override
  bool get isNull => false;

  @override
  bool get isMissing => false;

  @override
  bool? asBoolean() => null;

  @override
  int? asInt() => null;

  @override
  double? asDouble() => null;

  @override
  String? asString() => null;

  @override
  DateTime? asDateTime() => date;

  @override
  List<T>? asList<T>() => null;

  @override
  Map<String, V>? asMap<V>() => null;

  @override
  T? as<T>() => null;

  @override
  dynamic get data => null;

  @override
  // TODO: implement isNotValid
  bool get isNotValid => throw UnimplementedError();

  @override
  // TODO: implement isValid
  bool get isValid => throw UnimplementedError();
}
