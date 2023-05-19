import 'package:dart_jwt/ext/string_extension.dart';
import 'package:intl/intl.dart';

final invalidDateTime = DateTime(0, 0, 0, 0, 0, 0, 0, 0);

extension DateTimeExtension on DateTime {
  String toFormattedString([String format = 'yyyy-MM-dd HH:mm:ss']) {
    return DateFormat(format).format(this);
  }

  bool get isValid => this != invalidDateTime;

  bool get isNotValid => !isValid;
}

DateTime dateTimeFromSeconds(dynamic value) =>
  value == null ?
  invalidDateTime :
  DateTime.fromMillisecondsSinceEpoch(value*1000);

DateTime jsonToDateTime(json) {
  if (json == null) {
    return invalidDateTime;
  }
  return json.toString().toDateTime();
}

