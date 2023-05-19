class InvalidObjectException implements Exception {

  final Type type;

  const InvalidObjectException(this.type);

  @override
  String toString() => 'This object of type $type is invalid';
}