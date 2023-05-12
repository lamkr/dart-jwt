import 'payload.dart';

abstract class PayloadDeserializer {
  Payload deserialize(String json);
}