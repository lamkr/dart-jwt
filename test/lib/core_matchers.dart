import 'package:dart_jwt/extensions.dart';
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

/// Returns a matcher that matches an invalid [DateTime].
const Matcher isNotValidDateTime = _IsNotValidDateTime();

class _IsNotValidDateTime extends Matcher {
  const _IsNotValidDateTime();

  @override
  bool matches(Object? item, Map matchState) =>
      (item as DateTime) == invalidDateTime;

  @override
  Description describe(Description description) =>
      description.add('not valid DateTime');
}

/// Returns a matcher that matches an valid [DateTime].
const Matcher isValidDateTime = _IsValidDateTime();

class _IsValidDateTime extends Matcher {
  const _IsValidDateTime();

  @override
  bool matches(Object? item, Map matchState) =>
      (item as DateTime) != invalidDateTime;

  @override
  Description describe(Description description) =>
      description.add('not valid DateTime');
}
