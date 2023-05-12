import 'package:dart_jwt/null_safety_object.dart';

/// The Payload class represents the 2nd part of the JWT,
/// where the Payload value is held.
abstract class Payload implements NullSafetyObject {

  /// Get the value of the "sub" claim, or empty if it's not available.
  String get subject;
}