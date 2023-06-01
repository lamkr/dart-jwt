import 'dart:typed_data';

import 'package:dart_jwt/extensions.dart';
import 'package:dart_jwt/pem.dart';

/// A generic PEM object - type, header properties, and byte content.
class PemObject implements NullSafetyObject
{
  static final invalid = _EmptyPemObject();

  final String type;
  final List<PemHeader> headers;
  final Uint8List content;

  PemObject(String type, Uint8List content)
      : this.withHeaders(type, List.empty(), content);

  PemObject.withHeaders(this.type, this.headers, this.content);

  @override
  bool get isNotValid => !isValid;

  @override
  bool get isValid => true;
}

class _EmptyPemObject extends PemObject {
  _EmptyPemObject()
      : super('', Uint8List.fromList(List.unmodifiable([])));

  @override
  bool get isValid => false;
}