import '../null_safety_object.dart';
import 'header.dart';
import 'payload.dart';

/// Class that represents a Json Web Token that was decoded
/// from it's string representation.
abstract class DecodedJWT implements Payload, Header, NullSafetyObject
{
  static const DecodedJWT empty = _EmptyDecodedJWT();

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  const DecodedJWT();

  @override
  String getSubject() {
    return '';
  }
}

class _EmptyDecodedJWT extends DecodedJWT {

  const _EmptyDecodedJWT() : super();

  @override
  bool get isEmpty => true;
}