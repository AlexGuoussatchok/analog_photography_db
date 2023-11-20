import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ChemicalsDatabaseHelper {
  static const _dbName = 'chemicals_catalogue.db';
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  static Future<Database> _initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    // Copy from assets if not exist
    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load(join('assets/databases', _dbName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getChemicals(String table, String columnName) async {
    final db = await database;

    if (db == null) {
      throw Exception("Database not initialized");
    }

    final result = await db.query(table, columns: [columnName]);
    return result;
  }
}
