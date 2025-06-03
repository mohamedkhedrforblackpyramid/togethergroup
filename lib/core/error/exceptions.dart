class ServerException implements Exception {
  final String message;

  const ServerException({
    this.message = 'Server error occurred',
  });

  @override
  String toString() => message;
}

class CacheException implements Exception {}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Network error occurred',
  });

  @override
  String toString() => message;
} 