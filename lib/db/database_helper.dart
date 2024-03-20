import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static const String tableName = 'Score';
  static const String columnId = 'id';
  static const String columnScore = 'high_score';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'your_database.db');

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnScore INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> updateHighScore(int score) async {
    final db = await database;
    await db.insert(
      tableName,
      {columnScore: score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<int?> getHighScore() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT [$columnScore] FROM $tableName ORDER BY [$columnScore] DESC LIMIT 1',
    );
    if (result.isNotEmpty) {
      return result.first[columnScore] as int;
    }
    return null;
  }
}
