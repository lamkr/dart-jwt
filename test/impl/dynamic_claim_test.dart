import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main()
{
  test('shouldGetBooleanValue', () {
    final claim = DynamicClaim(true);

    expect(claim.asBoolean(), isNotNull);
    expect(claim.asBoolean(), true);
  });

  test('shouldGetNullBooleanIfNotBooleanValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asBoolean(), isNull);
    claim = DynamicClaim('bool');
    expect(claim.asBoolean(), isNull);
  });

  test('shouldGetIntValue', () {
    var claim = DynamicClaim(123);
    expect(claim.asInt(), isNotNull);
    expect(claim.asInt(), 123);
  });

  test('shouldGetNullIntIfNotIntValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asInt(), isNull);
    claim = DynamicClaim('123');
    expect(claim.asInt(), isNull);
  });

  test('shouldGetDoubleValue', () {
    var claim = DynamicClaim(1.5);
    expect(claim.asDouble(), isNotNull);
    expect(claim.asDouble(), 1.5);
  });

  test('shouldGetNullDoubleIfNotDoubleValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asDouble(), isNull);
    claim = DynamicClaim('123.23');
    expect(claim.asDouble(), isNull);
  });

  test('shouldGetNumericDateValue', () {
    const seconds = 1476824844;
    var claim = DynamicClaim(seconds);
    expect(claim.asDateTime(), DateTime.fromMillisecondsSinceEpoch(seconds*1000));
  });

  test('shouldGetNullIfNotNumericDateValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asDateTime(), isNull);
    claim = DynamicClaim('1476824844');
    expect(claim.asDateTime(), isNull);
  });

  test('shouldGetStringValue', () {
    const seconds = 1476824844;
    var claim = DynamicClaim('string');
    expect(claim.asString(), isNotNull);
    expect(claim.asString(), 'string');
  });

  test('shouldGetNullStringIfNotStringValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asString(), isNull);
    claim = DynamicClaim(12345);
    expect(claim.asString(), isNull);
  });

  //TODO shouldGetArrayValueOfCustomClass

}
