import 'dart:io';

import 'package:dart_jwt/pem.dart';
import 'package:test/test.dart';

import '../lib.dart';

void main() {
  test('Should read a valid PEM object from file', () async {
    final file = File('assets/rsa-public.pem');
    final reader = PemReader(file.readAsLinesSync());
    final pem = reader.readPemObject();
    expect(pem, isValid);
  });
}