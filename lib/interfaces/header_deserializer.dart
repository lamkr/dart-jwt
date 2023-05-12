import 'header.dart';

abstract class HeaderDeserializer {
  Header deserialize(String json);
}