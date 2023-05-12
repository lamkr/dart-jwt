
import 'package:dart_jwt/interfaces/header_params.dart';
import 'package:intl/intl.dart';

import '../interfaces/header.dart';

// Implements the [Header] interface.
class BasicHeader implements Header
{
  final String _algorithm;
  final String _type;
  final String _contentType;
  final String _keyId;

  BasicHeader(
    this._algorithm,
    this._type,
    this._contentType,
    this._keyId);

  @override
  bool get isEmpty => false;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  String get algorithm => _algorithm;

  @override
  String get contentType => _contentType;

  @override
  dynamic headerClaim(String name) {
    // TODO: implement headerClaim
    throw UnimplementedError();
  }

  @override
  String get keyId => _keyId;

  @override
  String get type => _type;

  factory BasicHeader.fromJson(Map<String, dynamic> json) {
    //return _$BasicHeaderFromJson(json);
    final algorithm = json[HeaderParams.algorithm];
    final type = json[HeaderParams.type];
    final contentType = json[HeaderParams.contentType];
    final keyId = json[HeaderParams.keyId];
    //jsonToDateTime(json['dataRecebimento']),
    //Double.tryParse(json['latitudeInicio'], latitudeInvalida),
    return BasicHeader(algorithm, type, contentType, keyId);
  }

  /// Connect the generated [_$JWTDecoderToJson] function
  /// to the `toJson` method.
  Map<String, dynamic> toJson() {
    // TODO: implement
    return {};
    //return _$JWTDecoderToJson(this);
  }
}

// date_time_extension.dart
final invalidDateTime = DateTime(0,0,0,0,0,0,0,0);

extension DateTimeExtension on DateTime
{
  String toFormattedString([String format = 'yyyy-MM-dd HH:mm:ss']) {
    return DateFormat(format).format(this);
  }
}

DateTime jsonToDateTime(json) {
  if( json == null ) {
    return invalidDateTime;
  }
  return json.toString().toDateTime();
}

// double.dart

class Double {
  static double tryParse(var value, double valueIfError) {
    if (value is int) {
      return 0.0 + value;
    }
    else if (value is String && value.isNotEmpty) {
      return double.parse(value);
    }
    else if (value is double) {
      return value;
    }
    return valueIfError;
  }

  static bool equals(double value1, double value2) =>
      (value1.isNaN && value2.isNaN) || value1 == value2;
}

extension DoubleExtension on double {
  bool greaterThan(double value) => compareTo(value) > 0;

  bool lessThan(double value) => compareTo(value) < 0;

  bool equals(double value) => compareTo(value) == 0;
}

// string_extension.dart

extension StringExtension on String
{
  double toDouble() => double.parse(this);

  /// Converte uma string para DateTime de acordo com o formato especificado.
  DateTime toDateTime({String format='yyyy-MM-dd HH:mm:ss'}) {
    return DateFormat(format).parse(this);
  }

  /// Remove o último caracter na útima posição da string
  /// caso ele exista.
  String removeCharAtLastPositionIfExists(String chr) {
    if( substring(length-1) == chr ) {
      return substring(0, length-1);
    }
    return this;
  }

  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String mid(int start, [int? size]) {
    if( size == null ) {
      return substring(start);
    }
    if( size > length ) {
      size = length;
    }
    return substring(start, start+size);
  }

  String right(int size) {
    if( size > length ) {
      size = length;
    }
    return substring( length-size );
  }

  String left(int size) {
    if( size > length ) {
      size = length;
    }
    return substring( 0, size );
  }
}