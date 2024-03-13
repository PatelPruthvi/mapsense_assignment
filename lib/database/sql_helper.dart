import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class SQLHelper {
  static Future<sql.Database> db() async {
    return await sql.openDatabase('maps_db', version: 1,
        onCreate: (db, version) async {
      if (kDebugMode) {
        print('Creating a table...');
        await TableHelper.createTable(db);
      }
    });
  }
}

class TableHelper {
  static const String coordsTableName = 'coords';
  static Future createTable(sql.Database database) async {
    database.execute(
        ''' CREATE TABLE $coordsTableName (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, lat REAL, long REAL )''');
  }

  static Future createItem(CoordsModel coords) async {
    final db = await SQLHelper.db();
    final jsonCoords = coords.toJson();
    await db.insert(coordsTableName, jsonCoords,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllCoords() async {
    final db = await SQLHelper.db();
    return await db.query(coordsTableName);
  }

  static Future deleteCoord(CoordsModel coords) async {
    final db = await SQLHelper.db();
    await db.delete(coordsTableName, where: "id=?", whereArgs: [coords.id]);
  }
}
