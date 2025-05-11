import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';
import '../models/community.dart';
import '../models/health_tip.dart';
import '../models/challenge.dart';

class DatabaseHelper extends ChangeNotifier {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sportlog.db');
    debugPrint('Database initialized at path: ${await getDatabasesPath()}');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      debugPrint('Opening database at: $path');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future _createDB(Database db, int version) async {
    try {
      debugPrint('Creating database tables...');
      await db.execute('''
        CREATE TABLE activities (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          type TEXT NOT NULL,
          duration INTEGER NOT NULL,
          date TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE communities (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          sportType TEXT NOT NULL,
          location TEXT NOT NULL,
          schedule TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE health_tips (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sportType TEXT NOT NULL,
          tip TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE challenges (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          target INTEGER NOT NULL,
          duration TEXT NOT NULL
        )
      ''');
      // Insert 7 health tips (2 awal + 5 baru)
      await db.insert('health_tips', {
        'sportType': 'Lari',
        'tip': 'Lakukan pemanasan 10 menit sebelum lari untuk mencegah cedera.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Lari - Lakukan pemanasan 10 menit sebelum lari untuk mencegah cedera.');
      await db.insert('health_tips', {
        'sportType': 'Yoga',
        'tip': 'Minum air putih setelah yoga untuk hidrasi tubuh.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Yoga - Minum air putih setelah yoga untuk hidrasi tubuh.');
      await db.insert('health_tips', {
        'sportType': 'Bersepeda',
        'tip': 'Periksa tekanan ban sebelum bersepeda untuk keselamatan.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Bersepeda - Periksa tekanan ban sebelum bersepeda untuk keselamatan.');
      await db.insert('health_tips', {
        'sportType': 'Renang',
        'tip': 'Hindari menyelam di air dangkal untuk mencegah cedera kepala.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Renang - Hindari menyelam di air dangkal untuk mencegah cedera kepala.');
      await db.insert('health_tips', {
        'sportType': 'Fitness',
        'tip': 'Gunakan sepatu yang tepat untuk mendukung latihan kekuatan.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Fitness - Gunakan sepatu yang tepat untuk mendukung latihan kekuatan.');
      await db.insert('health_tips', {
        'sportType': 'Lari',
        'tip': 'Gunakan pakaian yang nyaman dan menyerap keringat saat lari.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Lari - Gunakan pakaian yang nyaman dan menyerap keringat saat lari.');
      await db.insert('health_tips', {
        'sportType': 'Yoga',
        'tip': 'Lakukan peregangan setelah yoga untuk meningkatkan fleksibilitas.',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted tip: Yoga - Lakukan peregangan setelah yoga untuk meningkatkan fleksibilitas.');
      debugPrint('Database tables and 7 health tips created successfully.');
    } catch (e) {
      debugPrint('Error creating database tables: $e');
      rethrow;
    }
  }

  Future<int> insertActivity(Activity activity) async {
    try {
      final db = await database;
      debugPrint('Inserting activity: ${activity.toMap()}');
      int result = await db.insert(
        'activities',
        activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Insert activity result: $result');
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error inserting activity: $e');
      rethrow;
    }
  }

  Future<List<Activity>> getActivities() async {
    try {
      final db = await database;
      final maps = await db.query('activities');
      debugPrint('Fetched activities: $maps');
      return List.generate(maps.length, (i) => Activity.fromMap(maps[i]));
    } catch (e) {
      debugPrint('Error fetching activities: $e');
      return [];
    }
  }

  Future<int> deleteActivity(int id) async {
    try {
      final db = await database;
      int result = await db.delete('activities', where: 'id = ?', whereArgs: [id]);
      debugPrint('Deleted activity with id $id, result: $result');
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error deleting activity: $e');
      return 0;
    }
  }

  Future<int> insertCommunity(Community community) async {
    try {
      final db = await database;
      debugPrint('Inserting community: ${community.toMap()}');
      int result = await db.insert(
        'communities',
        community.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Insert community result: $result');
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error inserting community: $e');
      rethrow;
    }
  }

  Future<List<Community>> getCommunities() async {
    try {
      final db = await database;
      final maps = await db.query('communities');
      debugPrint('Fetched communities: $maps');
      return List.generate(maps.length, (i) => Community.fromMap(maps[i]));
    } catch (e) {
      debugPrint('Error fetching communities: $e');
      return [];
    }
  }

  Future<int> insertHealthTip(HealthTip tip) async {
    try {
      final db = await database;
      debugPrint('Inserting health tip: ${tip.toMap()}');
      int result = await db.insert(
        'health_tips',
        tip.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Insert health tip result: $result');
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error inserting health tip: $e');
      rethrow;
    }
  }

  Future<List<HealthTip>> getHealthTips() async {
    try {
      final db = await database;
      final maps = await db.query('health_tips');
      debugPrint('Fetched health tips: $maps');
      return List.generate(maps.length, (i) => HealthTip.fromMap(maps[i]));
    } catch (e) {
      debugPrint('Error fetching health tips: $e');
      return [];
    }
  }

  Future<int> insertChallenge(Challenge challenge) async {
    try {
      final db = await database;
      debugPrint('Inserting challenge: ${challenge.toMap()}');
      int result = await db.insert(
        'challenges',
        challenge.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Insert challenge result: $result');
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('Error inserting challenge: $e');
      rethrow;
    }
  }

  Future<List<Challenge>> getChallenges() async {
    try {
      final db = await database;
      final maps = await db.query('challenges');
      debugPrint('Fetched challenges: $maps');
      return List.generate(maps.length, (i) => Challenge.fromMap(maps[i]));
    } catch (e) {
      debugPrint('Error fetching challenges: $e');
      return [];
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
      debugPrint('Database closed successfully.');
    } catch (e) {
      debugPrint('Error closing database: $e');
    }
  }
}