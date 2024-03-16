import 'package:assignment_mapsense/exceptions/app_exceptions.dart';
import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper {
  static Future<sql.Database> db() async {
    return await sql.openDatabase('maps_1.db', version: 1,
        onCreate: (db, version) async {
      if (kDebugMode) {
        print('Creating a table...');
      }
      await TableHelper.createTable(db);
    });
  }
}

class TableHelper {
  static const String coordsTableName = 'coords';
  static Future createTable(sql.Database database) async {
    database.execute(
        ''' CREATE TABLE $coordsTableName (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        lat REAL, 
        long REAL,
        address TEXT,
        markerTitle TEXT,
        markerSubTitle TEXT
         )''');
  }

  static Future<int> createItem(CoordsModel coords) async {
    final db = await SQLHelper.db();

    String address = '';
    String markerTitle = '';
    String markerSubTitle = '';
    // get history_screen's location name, map marker's title and subtitle from these things
    await placemarkFromCoordinates(coords.lat!, coords.long!).then((value) {
      if (value.isNotEmpty) {
        markerTitle = value[0].name ?? '';
        markerSubTitle = value[0].locality ?? '';
        address = "${value[0].subLocality}, ${value[0].locality}";
        coords.address = address;
        coords.markerSubTitle = markerSubTitle;
        coords.markerTitle = markerTitle;
      }
    }).onError((error, stackTrace) {
      throw LocationNameLoadException();
    });
    final jsonCoords = coords.toJson();
    return await db
        .insert(coordsTableName, jsonCoords,
            conflictAlgorithm: ConflictAlgorithm.replace)
        .onError((error, stackTrace) {
      throw CreateItemException();
    });
  }

  static Future<List<Map<String, dynamic>>> getAllCoords() async {
    final db = await SQLHelper.db();
    return await db.query(coordsTableName).onError((error, stackTrace) {
      throw DataFetchException();
    });
  }

  static Future<int> deleteCoord(int id) async {
    final db = await SQLHelper.db();
    return await db.delete(coordsTableName,
        where: "id=?", whereArgs: [id]).onError((error, stackTrace) {
      throw DeleteItemException();
    });
  }
}
