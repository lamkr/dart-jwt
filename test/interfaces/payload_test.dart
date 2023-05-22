import 'package:dart_jwt/ext/date_time_extension.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:dart_jwt/interfaces/claim.dart';
import 'package:test/test.dart';

void main() {
  test('Should get datetime from default', () {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(1646667492000);
    Payload payload = PayloadImplForTest(date);
    expect(payload.expiresAt, date);
    expect(payload.issuedAt, date);
    expect(payload.notBefore, date);
  });

  test('Should get datetime from default as null', () {
    Payload payload = PayloadImplForTest(invalidDateTime);
    expect(payload.expiresAt, invalidDateTime);
    expect(payload.issuedAt, invalidDateTime);
    expect(payload.notBefore, invalidDateTime);
  });
}

class PayloadImplForTest implements Payload {
  final DateTime date;

  PayloadImplForTest(this.date);
  @override
  bool get isNotValid => throw UnimplementedError();

  @override
  bool get isValid => throw UnimplementedError();

  @override
  List<String> get audience => [];

  @override
  Claim claim(String name) => Claim.invalid;

  @override
  Map<String, Claim> get claims => {};

  @override
  DateTime get expiresAt => date;

  @override
  String get id => '';

  @override
  DateTime get issuedAt => date;

  @override
  String get issuer => '';

  @override
  DateTime get notBefore => date;

  @override
  String get subject => '';

  @override
  Map<String, dynamic> toJson() => {};
}
