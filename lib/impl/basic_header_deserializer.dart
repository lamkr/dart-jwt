import 'package:dart_jwt/interfaces/header.dart';

import '../interfaces/header_deserializer.dart';

class BasicHeaderDeserializer implements HeaderDeserializer {
  const BasicHeaderDeserializer();

  @override
  Header deserialize(String json) {
    // TODO: implement deserialize
    throw UnimplementedError();
  }
}