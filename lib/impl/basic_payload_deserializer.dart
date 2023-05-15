import 'dart:convert';

import 'package:dart_jwt/impl/basic_payload.dart';

import '../interfaces/payload.dart';
import '../interfaces/payload_deserializer.dart';

class BasicPayloadDeserializer implements PayloadDeserializer {
  const BasicPayloadDeserializer();

  @override
  Payload deserialize(String source) {
    final json = jsonDecode(source);
    return BasicPayload.fromJson(json);
  }
}