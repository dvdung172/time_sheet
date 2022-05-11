class RemoteException implements Exception {
  const RemoteException({
    required this.errorMessage,
  });

  final String errorMessage;
}
