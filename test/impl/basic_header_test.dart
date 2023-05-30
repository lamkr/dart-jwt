import 'package:dart_jwt/impl.dart';
import 'package:dart_jwt/interfaces.dart';
import 'package:test/test.dart';

void main() {
  test('shouldHaveUnmodifiableTreeWhenInstantiatedWithNonNullTree', () {
      BasicHeader header = BasicHeader('', '', '', '', <String, Claim>{});
      expect(() => header.tree["something"] = Claim.invalid,
          throwsUnsupportedError);
  });

  test('shouldHaveTree', () {
    final map = <String, Claim>{};
    final node = Claim.invalid;
    map["key"] = node;
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.tree, containsPair("key", node));
  });

  test('shouldGetAlgorithm', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('HS256', '', '', '', map);
    expect(header.algorithm, isNotEmpty);
    expect(header.algorithm, 'HS256');
  });

  test('shouldGetEmptyAlgorithmIfMissing', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.algorithm, isEmpty);
  });

  test('shouldGetType', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', 'jwt', '', '', map);
    expect(header.type, isNotEmpty);
    expect(header.type, 'jwt');
  });

  test('shouldGetEmptyTypeIfMissing', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.type, isEmpty);
  });

  test('shouldGetContentType', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', 'content', '', map);
    expect(header.contentType, isNotEmpty);
    expect(header.contentType, 'content');
  });

  test('shouldGetEmptyContentTypeIfMissing', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.contentType, isEmpty);
  });

  test('shouldGetKeyId', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', '', 'key', map);
    expect(header.keyId, isNotEmpty);
    expect(header.keyId, 'key');
  });

  test('shouldGetEmptyKeyIdIfMissing', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.keyId, isEmpty);
  });


  test('shouldGetExtraClaim', () {
    final map = <String, Claim>{};
    map['extraClaim'] = DynamicClaim('extraValue');
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.headerClaim('extraClaim'), isA<Claim>() );
    expect(header.headerClaim('extraClaim').asString(), 'extraValue' );
  });

  test('shouldGetNotNullExtraClaimIfMissing', () {
    final map = <String, Claim>{};
    BasicHeader header = BasicHeader('', '', '', '', map);
    expect(header.headerClaim('missing'), isNotNull );
    expect(header.headerClaim('missing').isMissing, isTrue);
    expect(header.headerClaim('missing').isNull, isFalse);
  });
}
