import 'package:dart_jwt/exceptions.dart';
import 'package:dart_jwt/impl.dart';
import 'package:test/test.dart';

void main() {

  final parser = JWTParser();

  test('shouldParsePayload', () {
    parser.parsePayload("{}");
  });

  test('shouldThrowOnInvalidPayload', () {
    try {
      String jsonPayload = "{{";
      final payload = parser.parsePayload(jsonPayload);
      expect(payload, isNull);
    }catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          "The string '{{' doesn't have a valid JSON format.");
    }
  });

  test('shouldParseHeader', () {
    parser.parseHeader("{}");
  });

  test('shouldThrowOnInvalidHeader', () {
    try {
      String jsonPayload = "}}";
      final header = parser.parseHeader(jsonPayload);
      expect(header, isNull);
    }catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          "The string '}}' doesn't have a valid JSON format.");
    }
  });

  test('shouldThrowWhenConvertingHeaderIfNullJson', () {
    try {
      parser.parseHeader('');
    }catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          "The string '' doesn't have a valid JSON format.");
    }
  });

  test('shouldThrowWhenConvertingHeaderFromInvalidJson', () {
    try {
      parser.parseHeader("}{");
    }catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          "The string '}{' doesn't have a valid JSON format.");
    }
  });

  test('shouldThrowWhenConvertingPayloadIfNullJson', () {
    try {
      parser.parsePayload('');
    }catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          "The string '' doesn't have a valid JSON format.");
    }
  });

  test('shouldThrowWhenConvertingPayloadFromInvalidJson', () {
    try {
      parser.parsePayload("}{");
    }catch(e) {
      expect(e, isA<JWTDecodeException>());
      expect((e as JWTDecodeException).message,
          "The string '}{' doesn't have a valid JSON format.");
    }
  });

}
