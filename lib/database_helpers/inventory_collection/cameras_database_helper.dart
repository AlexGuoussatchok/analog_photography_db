import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:analog_photography_db/models/inventory_camera.dart';

class CamerasDatabaseHelper {
  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'inventory_collection.db');
    return openDatabase(path);
  }

  static Future<int> insertCamera(InventoryCamera camera) async {
    final db = await _initDatabase();
    return await db.insert('cameras', camera.toMap());
  }

  static Future<InventoryCamera?> getCamera(int id) async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('cameras', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return InventoryCamera.fromMap(maps.first);
    }
    return null;
  }

  // This is a helper method to fetch all cameras for displaying
  static Future<List<InventoryCamera>> fetchCameras() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('cameras');
    return maps.map((cameraMap) => InventoryCamera.fromMap(cameraMap)).toList();
  }
}
