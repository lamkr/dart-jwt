import 'dart:convert';

abstract class JsonSerializable {

  Map<String, dynamic> toJson();

  @override
  String toString() => jsonEncode(this);
}
