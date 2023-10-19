import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:analog_photography_db/models/inventory_films.dart';

class FilmsDatabaseHelper {
  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'inventory_collection.db');
    return openDatabase(path);
  }

  static Future<int> insertFilms(InventoryFilms films) async {
    final db = await _initDatabase();
    return await db.insert('films', films.toMap());
  }

  static Future<InventoryFilms?> getFilms(int id) async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('films', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InventoryFilms.fromMap(maps.first);
    }
    return null;
  }

  // This is a helper method to fetch all films for displaying
  static Future<List<InventoryFilms>> fetchFilms() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('films');
    return maps.map((filmsMap) => InventoryFilms.fromMap(filmsMap)).toList();
  }
}
