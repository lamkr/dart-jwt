class InvalidObjectException implements Exception {

  final String typeName;

  const InvalidObjectException(this.typeName);

  @override
  String toString() => 'This object of type $typeName is invalid';
}