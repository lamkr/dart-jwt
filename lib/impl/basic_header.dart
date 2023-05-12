
import '../interfaces/header.dart';

// Implements the [Header] interface.
class BasicHeader implements Header
{
  final String _algorithm;
  final String _type;
  final String _contentType;
  final String _keyId;

  BasicHeader(
    this._algorithm,
    this._type,
    this._contentType,
    this._keyId);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  String get algorithm => _algorithm;

  @override
  String get contentType => _contentType;

  @override
  dynamic headerClaim(String name) {
    // TODO: implement headerClaim
    throw UnimplementedError();
  }

  @override
  String get keyId => _keyId;

  @override
  String get type => _type;
}