import 'package:dart_jwt/ext/null_safety_object.dart';
import 'package:test/test.dart';

/// Returns a matcher that matches the isValid property of [NullSafetyObject].
const Matcher isValid = _IsValid();

class _IsValid extends Matcher {
  const _IsValid();

  @override
  bool matches(Object? item, Map matchState) =>
      (item as NullSafetyObject).isValid;

  @override
  Description describe(Description description) =>
      description.add('valid');
}

/// Returns a matcher that matches the isNotValid property of [NullSafetyObject].
const Matcher isNotValid = _IsNotValid();

class _IsNotValid extends Matcher {
  const _IsNotValid();

  @override
  bool matches(Object? item, Map matchState) =>
      (item as NullSafetyObject).isNotValid;

  @override
  Description describe(Description description) =>
      description.add('not valid');
}
