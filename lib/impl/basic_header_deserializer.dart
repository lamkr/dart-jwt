import 'dart:convert';

import 'package:dart_jwt/impl/basic_header.dart';
import 'package:dart_jwt/interfaces/header.dart';

import '../interfaces/header_deserializer.dart';

class BasicHeaderDeserializer implements HeaderDeserializer {
  const BasicHeaderDeserializer();

  @override
  Header deserialize(String source) {
    final json = jsonDecode(source);
    return BasicHeader.fromJson(json);
  }
}