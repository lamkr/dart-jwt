import 'package:dart_jwt/interfaces/header.dart';

abstract class HeaderDeserializer {
  Header deserialize(String json);
}