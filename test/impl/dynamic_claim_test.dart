import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

import '../user_pojo.dart';

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
    final claim = DynamicClaim(123);
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
    final claim = DynamicClaim(1.5);
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
    final claim = DynamicClaim(seconds);
    expect(claim.asDateTime(), DateTime.fromMillisecondsSinceEpoch(seconds*1000));
  });

  test('shouldGetNullIfNotNumericDateValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asDateTime(), isNull);
    claim = DynamicClaim('1476824844');
    expect(claim.asDateTime(), isNull);
  });

  test('shouldGetStringValue', () {
    final claim = DynamicClaim('string');
    expect(claim.asString(), isNotNull);
    expect(claim.asString(), 'string');
  });

  test('shouldGetNullStringIfNotStringValue', () {
    var claim = DynamicClaim(Object());
    expect(claim.asString(), isNull);
    claim = DynamicClaim(12345);
    expect(claim.asString(), isNull);
  });

  test('shouldGetListValueOfCustomClass', () {
    final claim = DynamicClaim([UserPojo("George", 1), UserPojo("Mark", 2)]);
    expect(claim.asList<UserPojo>(), isNotNull);
    expect(claim.asList<UserPojo>(), containsAll([UserPojo("George", 1), UserPojo("Mark", 2)]));
  });

  test('shouldGetListValue', () {
    final claim = DynamicClaim(["string1", "string2"]);
    expect(claim.asList<String>(), isNotNull);
    expect(claim.asList<String>(), containsAll(["string1", "string2"]));
  });

  test('shouldGetNullArrayIfNullValue', () {
    final claim = DynamicClaim(null);
    expect(claim.asList<dynamic>(), isNull);
  });

  test('shouldGetNullListIfNonArrayValue', () {
    final claim = DynamicClaim(1);
    expect(claim.asList<dynamic>(), isNull);
  });

  test('shouldThrowIfListClassMismatch', () {
    final claim = DynamicClaim(["keys", "values"]);
    expect(() => claim.asList<UserPojo>(), throwsA(isA<JWTDecodeException>()));
  });

  test('shouldGetNullMapIfNullValue', () {
    final claim = DynamicClaim(null);
    expect(claim.asMap(), isNull);
  });

  test('shouldGetNullMapIfNonArrayValue', () {
    final claim = DynamicClaim(1);
    expect(claim.asMap(), isNull);
  });

  test('shouldGetMapValue', () {
    final map = <String, dynamic>{
      "text": "extraValue",
      "number": 12,
      "boolean": true,
      "object": <String,String>{"something":"else"}
    };
    final claim = DynamicClaim(map);

    final backMap = claim.asMap<dynamic>();
    expect(backMap, isNotNull);
    expect(backMap, containsPair("text", "extraValue"));
    expect(backMap, containsPair("number", 12));
    expect(backMap, containsPair("boolean", true));
    expect(backMap, containsPair("object", <String,String>{"something":"else"}));
  });

  test('shouldGetCustomClassValue', () {
    final claim = DynamicClaim(UserPojo("John", 123));
    expect(claim.as<UserPojo>()?.name, "John");
    expect(claim.as<UserPojo>()?.id, 123);
  });

  test('shouldThrowIfCustomClassMismatch', () {
    final claim = DynamicClaim(UserPojo("John", 123));
    expect(() => claim.as<String>(), throwsA(isA<JWTDecodeException>()));
  });

  test('shouldReturnNullForMissingAndNullClaims', () {
    final missingValue = Claim.missing;
    expect(missingValue.isMissing, isTrue);
    expect(missingValue.isNull, isFalse);
    expect(missingValue.as<String>(), isNull);
    expect(missingValue.asString(), isNull);
    expect(missingValue.asBoolean(), isNull);
    expect(missingValue.asDateTime(), isNull);
    expect(missingValue.asDouble(), isNull);
    expect(missingValue.asInt(), isNull);
    expect(missingValue.asMap(), isNull);
    expect(missingValue.asList(), isNull);

    final nullClaim = Claim.nullClaim;
    expect(nullClaim.isMissing, isFalse);
    expect(nullClaim.isNull, isTrue);
    expect(nullClaim.as<String>(), isNull);
    expect(nullClaim.asString(), isNull);
    expect(nullClaim.asBoolean(), isNull);
    expect(nullClaim.asDateTime(), isNull);
    expect(nullClaim.asDouble(), isNull);
    expect(nullClaim.asInt(), isNull);
    expect(nullClaim.asMap(), isNull);
    expect(nullClaim.asList(), isNull);
  });

  test('shouldReturnNullForInvalidArrayValue', () {
    final claim = DynamicClaim(UserPojo("John", 123));
    expect(claim.asList<String>(), isNull);
  });

  test('shouldGetAsMapValue', () {
    final claim = DynamicClaim(<String, UserPojo>{"key":UserPojo("John", 123)});
    final map = claim.as<Map<String,UserPojo>>();
    expect(map?['key']?.name, 'John');
    expect(map?['key']?.id, 123);
  });

  test('shouldReturnBaseClaimWhenParsingMissingNode', () {
    final claim = Claim.missing;
    expect(claim.isMissing, isTrue);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnBaseClaimWhenParsingNullNode', () {
    final claim = Claim.nullClaim;
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isTrue);
  });

  test('shouldReturnBaseClaimWhenParsingNullValue', () {
    final claim = DynamicClaim(null);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isTrue);
  });

  test('shouldReturnBaseClaimWhenParsingNullValue', () {
    final claim = DynamicClaim(Object());
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNonNullClaimWhenParsingList', () {
    final claim = DynamicClaim(<String>[]);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNonNullClaimWhenParsingStringValue', () {
    final claim = DynamicClaim("");
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNonNullClaimWhenParsingIntValue', () {
    final claim = DynamicClaim(Int.max);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNonNullClaimWhenParsingDoubleValue', () {
    final claim = DynamicClaim(double.maxFinite);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNonNullClaimWhenParsingDateValue', () {
    final claim = DynamicClaim(DateTime.now());
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNonNullClaimWhenParsingBooleanValue', () {
    final claim = DynamicClaim(true);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isFalse);
  });

  test('shouldReturnNullIsTrue', () {
    final claim = DynamicClaim(null);
    expect(claim.isMissing, isFalse);
    expect(claim.isNull, isTrue);
  });

  test('shouldDelegateToObjectToString', () {
    final claim = DynamicClaim(UserPojo("john", 123));
    expect(claim.toString(), isA<String>());
  });

  test('shouldConvertToString', () {
    final claim = DynamicClaim(UserPojo("john", 123));
    final nullClaim = Claim.nullClaim;
    final missingClaim = Claim.missing;

    expect(claim.toString(), '{"name":"john","id":123}');
    expect(nullClaim.isNull, isTrue);
    expect(nullClaim.toString(), 'Null claim');
    expect(missingClaim.isMissing, isTrue);
    expect(missingClaim.toString(), 'Missing claim');
  });
}
