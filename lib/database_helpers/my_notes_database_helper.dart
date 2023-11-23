import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyNotesDatabaseHelper {
  static const _dbName = 'my_notes.db';
  static const _dbVersion = 1;
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  static Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_film_dev_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        film_number TEXT,
        film_name TEXT,
        film_type TEXT,
        film_size TEXT,
        film_expired TEXT,
        film_exp_date TEXT,
        camera TEXT,
        lenses TEXT,
        developer TEXT,
        lab TEXT,
        dilution TEXT,
        dev_time TEXT,
        temp TEXT,
        comments TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE my_films_history_notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        film_number TEXT
      );
    ''');
  }

  Future<List<Map<String, dynamic>>> getDevelopingNotes() async {
    final db = await database;
    if (db == null) {
      throw Exception("Database not initialized");
    }
    final List<Map<String, dynamic>> notes = await db.query('my_film_dev_notes');
    return notes;
  }

  Future<void> insertDevelopingNote(Map<String, dynamic> note) async {
    final db = await database;
    await db.insert(
      'my_film_dev_notes',
      note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


}
