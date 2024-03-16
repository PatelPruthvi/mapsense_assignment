import 'package:assignment_mapsense/database/sql_helper.dart';
import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  group('Database Tests', () {
    late sql.Database database;

    setUp(() async {
      // Initialize the database
      database = await SQLHelper.db();
    });

    test('Database can insert new item', () async {
      const double latitude = 22.3142;
      const double longitude = 73.1752;
      const String address = 'Alkapuri, Vadodara';
      const String markerTitle = 'Indubhai Patel Marg';
      const String markerSubTitle = 'Vadodara';
      final CoordsModel coords = CoordsModel(
          lat: latitude,
          long: longitude,
          address: address,
          markerSubTitle: markerSubTitle,
          markerTitle: markerTitle);
      // Insert a new item into the database
      final int id = await database.insert('coords', coords.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Verify that the item was inserted successfully
      expect(id, isNotNull);
    });

    test('Database can delete existing item', () async {
      const double latitude = 22.3142;
      const double longitude = 73.1752;
      const String address = 'Alkapuri, Vadodara';
      const String markerTitle = 'Indubhai Patel Marg';
      const String markerSubTitle = 'Vadodara';
      final CoordsModel coords = CoordsModel(
          lat: latitude,
          long: longitude,
          address: address,
          markerSubTitle: markerSubTitle,
          markerTitle: markerTitle);
      // Insert a new item into the database
      final int id = await database.insert('coords', coords.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      // Delete the item from the database
      final int rowsDeleted =
          await database.delete('coords', where: 'id=?', whereArgs: [id]);

      // Verify that the item was deleted successfully
      expect(rowsDeleted, equals(1));
    });
    tearDown(() {
      database.close();
    });
  });
}
