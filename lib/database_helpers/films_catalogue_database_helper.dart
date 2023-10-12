import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FilmsCatalogueDatabaseHelper {
  static const String dbName = 'films_catalogue.db';
  static const _databaseVersion = 20231012;
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

  static final FilmsCatalogueDatabaseHelper _instance = FilmsCatalogueDatabaseHelper._privateConstructor();
  factory FilmsCatalogueDatabaseHelper() {
    return _instance;
  }
  FilmsCatalogueDatabaseHelper._privateConstructor();


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

  Future<List<Map<String, dynamic>>> getFilmsBrands() async {
    final db = await database;
    try {
      return await db!.query('film_brands', columns: ['brand'], orderBy: 'brand ASC');
    } catch (e) {
      print("Error fetching lens brands: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFilmsNames(String brand) async {
    final db = await database;
    try {
      String tableName = '${brand.toLowerCase().replaceAll(' ', '_')}_films_catalogue';
      return await db!.query(tableName, columns: ['name'], orderBy: 'name ASC');
    } catch (e) {
      print("Error fetching films names from $brand: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> getItemDetails(String tableName, String name) async {
    final db = await database;
    try {
      var result = await db!.query(tableName, where: "name = ?", whereArgs: [name]);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        throw Exception('Film name not found in the database.');
      }
    } catch (e) {
      print("Error fetching item details for $name from $tableName: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getFilmsDetails(String brand, String name) async {
    String tableName = '${brand.toLowerCase().replaceAll(' ', '_')}_films_catalogue';
    return await getItemDetails(tableName, name);
  }



  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
