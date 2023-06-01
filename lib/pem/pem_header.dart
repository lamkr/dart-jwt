import 'package:dart_jwt/extensions.dart';

/// Class representing a PEM header (name, value) pair.
class PemHeader implements NullSafetyObject
{
  static const invalid = _EmptyPemHeader();

  final String name;
  final String value;

  const PemHeader(this.name, this.value);

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => true;

  @override
  int get hashCode => Object.hash(name, value);

  @override
  bool operator ==(Object other) =>
    other is PemHeader && other.name == name && other.value == value;
}

class _EmptyPemHeader extends PemHeader {
  const _EmptyPemHeader()
      : super('', '');

  @override
  bool get isValid => false;
}