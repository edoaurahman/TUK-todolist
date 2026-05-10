import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const _dbName = 'agenda_nusantara.db';
  static const _dbVersion = 1;
  static const tableTasks = 'tasks';

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = join(dir, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE $tableTasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            due_date TEXT NOT NULL,
            category TEXT NOT NULL,
            done INTEGER NOT NULL DEFAULT 0,
            completed_at TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertTask(Task t) async {
    final db = await database;
    return db.insert(tableTasks, t.toMap()..remove('id'));
  }

  Future<int> updateTask(Task t) async {
    final db = await database;
    return db.update(tableTasks, t.toMap(),
        where: 'id = ?', whereArgs: [t.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete(tableTasks, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final rows = await db.query(tableTasks, orderBy: 'due_date ASC');
    return rows.map(Task.fromMap).toList();
  }

  Future<int> countDone() async {
    final db = await database;
    final r = await db
        .rawQuery('SELECT COUNT(*) AS c FROM $tableTasks WHERE done = 1');
    return Sqflite.firstIntValue(r) ?? 0;
  }

  Future<int> countPending() async {
    final db = await database;
    final r = await db
        .rawQuery('SELECT COUNT(*) AS c FROM $tableTasks WHERE done = 0');
    return Sqflite.firstIntValue(r) ?? 0;
  }

  Future<Map<String, int>> donePerDay({int days = 7}) async {
    final db = await database;
    final r = await db.rawQuery('''
      SELECT substr(completed_at, 1, 10) AS d, COUNT(*) AS c
      FROM $tableTasks
      WHERE done = 1 AND completed_at IS NOT NULL
      GROUP BY d
      ORDER BY d DESC
      LIMIT $days
    ''');
    return {for (final row in r) row['d'] as String: (row['c'] as int)};
  }
}
