class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() {
    return 'AppException: $message';
  }
}

class NoInternetException extends AppException {
  NoInternetException() : super('No internet connection available.');
}

class DatabaseException extends AppException {
  DatabaseException(String message) : super('Database Exception: $message');
}

class CreateItemException extends DatabaseException {
  CreateItemException() : super('Unable to store item in database.');
}

class DeleteItemException extends DatabaseException {
  DeleteItemException() : super('Unable to delete item from database.');
}

class LocationPermissionDeniedException extends AppException {
  LocationPermissionDeniedException()
      : super('Location access permission denied. Enable from settings.');
}
