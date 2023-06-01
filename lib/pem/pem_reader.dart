import 'dart:convert';

import 'package:dart_jwt/pem.dart';

class PemReader {

  static const _begin = '-----BEGIN ';
  static const _end = '-----END ';
  static const _eof = '';

  final List<String> _lines;
  var _currentIndex = -1;
  
  PemReader(this._lines);

  /// Read the next PEM object as a blob of raw data with header information.
  PemObject readPemObject() {
    var line = '';
    while ((line = _nextLine()) != _eof) {
      if( line.startsWith(_begin) ) {
        line = line.substring(_begin.length);
        var index = line.indexOf('-');
        if (index > 0 && line.endsWith("-----") && (line.length - index) == 5) {
          String type = line.substring(0, index);
          return _loadObject(type);
        }
      }
    }
    return PemObject.invalid;
  }

  String _nextLine() {
    if( (_currentIndex+1) < _lines.length) {
      _currentIndex++;
      return _lines[_currentIndex];
    }
    return _eof;
  }

  PemObject _loadObject(String type) {
    var line = '';
    final endMarker = _end + type;
    final buf = StringBuffer();
    final headers = <PemHeader>[];

    while ((line = _nextLine()) != _eof) {
      final index = line.indexOf(':');
      if (index >= 0) {
        String hdr = line.substring(0, index);
        String value = line.substring(index + 1).trim();
        headers.add(PemHeader(hdr, value));
        continue;
      }
      if (line.contains(endMarker)) {
        break;
      }
      buf.write(line.trim());
    }
    if (line.isEmpty) {
      throw Exception("$endMarker not found");
    }
    return PemObject.withHeaders(
      type,
      List.unmodifiable(headers),
      base64Decode(buf.toString()),
    );
  }
}
