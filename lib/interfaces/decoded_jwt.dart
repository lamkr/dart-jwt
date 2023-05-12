import '../null_safety_object.dart';
import 'header.dart';
import 'payload.dart';

/// Class that represents a Json Web Token that was decoded
/// from it's string representation.
abstract class DecodedJWT implements Payload, Header, NullSafetyObject
{
  /// Getter for the String Token used to create this JWT instance.
  String get token;

  /// Getter for the Header contained in the JWT as a Base64 encoded String.
  /// This represents the first part of the token.
  String get header;

  /// Getter for the Payload contained in the JWT as a Base64 encoded String.
  /// This represents the second part of the token.
  String get payload;

  /// Getter for the Signature contained in the JWT as a Base64 encoded String.
  /// This represents the third part of the token.
  String get signature;
}
