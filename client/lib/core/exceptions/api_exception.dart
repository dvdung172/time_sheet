class ApiException implements Exception {
  const ApiException({required this.statusCode, required this.cause});

  final int statusCode;
  final String cause;

  @override
  String toString() => cause;
}
