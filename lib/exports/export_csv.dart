import 'dart:io';
import 'package:assignment_mapsense/database/sql_helper.dart';
import 'package:assignment_mapsense/exceptions/app_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:csv/csv.dart';

class ExportCsv {
  Future<String> exportDataToCsv() async {
    // Open the SQLite database
    final databasePath = await getDatabasesPath().onError((error, stackTrace) {
      throw CreateItemException();
    });
    final database = await openDatabase('$databasePath/maps_1.db')
        .onError((error, stackTrace) {
      throw CreateItemException();
    });

    // Query data from the database
    final List<Map<String, dynamic>> data = await database
        .query(TableHelper.coordsTableName)
        .onError((error, stackTrace) {
      throw DataFetchException();
    });

    // Convert the queried data to CSV format
    final List<List<dynamic>> csvData = [
      // Add headers
      [
        'id',
        'lat',
        'long',
        'address',
        'markerTitle',
        'markerSubTitle'
      ], // Adjust these headers based on your database schema

      // Add rows
      ...data.map((row) => [
            row['id'],
            row['lat'],
            row['long'],
            row['address'],
            row['markerTitle'],
            row['markerSubTitle']
          ]), // Adjust column names accordingly
    ];

    // Convert CSV data to a string
    final csvString = const ListToCsvConverter().convert(csvData);

    // Get the directory where the CSV file will be saved
    final directory =
        await getExternalStorageDirectory().onError((error, stackTrace) {
      throw CsvGenerationException();
    });
    final filePath = '${directory!.path}/data.csv';

    // Write the CSV data to a file
    final file = File(filePath);
    await file.writeAsString(csvString);

    return 'CSV file exported to: $filePath';
  }
}
