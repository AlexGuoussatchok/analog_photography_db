import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CamerasCatalogueDatabaseHelper {
  static const String dbName = 'cameras_catalogue.db';
  static const _databaseVersion = 20231009;
  static Database? _database;

  static Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initializeDatabase();
    return _database;
  }

  static Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    if (await databaseExists(path)) {
      return await openDatabase(path, version: _databaseVersion, onUpgrade: _onUpgrade);
    } else {
      ByteData data = await rootBundle.load(join('assets/databases', dbName));
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
      return await openDatabase(path, version: _databaseVersion);
    }
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, dbName);
      await db.close();
      await deleteDatabase(path);
      ByteData data = await rootBundle.load(join('assets/databases', dbName));
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }
  }

  Future<List<Map<String, dynamic>>> getCameraBrands() async {
    final db = await database;
    try {
      return await db!.query('camera_brands', columns: ['brand']);
    } catch (e) {
      print("Error fetching camera brands: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCameraModels(String tableName) async {
    final db = await database;
    try {
      return await db!.query(tableName, columns: ['model']);
    } catch (e) {
      print("Error fetching camera models from $tableName: $e");
      return [];
    }
  }


  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
