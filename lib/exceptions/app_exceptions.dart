// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() {
    return 'AppException: $message';
  }
}

class DatabaseException implements Exception {
  final String msg;
  DatabaseException(this.msg);
  @override
  String toString() {
    return 'Database Exception: $msg';
  }
}

class CreateItemException extends DatabaseException {
  CreateItemException() : super('Unable to store item in database.');
}

class DeleteItemException extends DatabaseException {
  DeleteItemException() : super('Unable to delete item from database.');
}

class DataFetchException extends DatabaseException {
  DataFetchException()
      : super(
            'Error fetching coordinates and location details from the database.');
}

class LocationPermissionDeniedException extends AppException {
  LocationPermissionDeniedException()
      : super('Location access permission denied. Enable from settings.');
}

class LocationNameLoadException extends AppException {
  LocationNameLoadException()
      : super(
            'Unable to retrieve address from coordinates. This could be due to low internet connection.');
}

class CsvGenerationException extends AppException {
  CsvGenerationException()
      : super(
            'Failed to generate CSV file. Check file permissions and try again.');
}
