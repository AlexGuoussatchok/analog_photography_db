import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:analog_photography_db/models/inventory_lenses.dart';

class LensesDatabaseHelper {
  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'inventory_collection.db');
    return openDatabase(path);
  }

  static Future<int> insertLenses(InventoryLenses lenses) async {
    final db = await _initDatabase();
    return await db.insert('lenses', lenses.toMap());
  }

  static Future<InventoryLenses?> getLenses(int id) async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('lenses', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InventoryLenses.fromMap(maps.first);
    }
    return null;
  }

  // This is a helper method to fetch all lenses for displaying
  static Future<List<InventoryLenses>> fetchLenses() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('lenses');
    return maps.map((lensesMap) => InventoryLenses.fromMap(lensesMap)).toList();
  }
}
