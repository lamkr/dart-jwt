import 'package:dart_jwt/null_safety_object.dart';

abstract class Header implements NullSafetyObject
{
  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;
}