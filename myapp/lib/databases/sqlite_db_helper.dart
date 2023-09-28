import 'dart:async';

import 'package:myapp/models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDBHelper {
  static Database? _database;
  static final String _tableName = 'tasks';
  static final String _fileName = 'tasks.db';
  int _limit = 10;
  int _offset = 0;

  StreamController<List<Task>> _tasksController = StreamController<List<Task>>.broadcast();
  Stream<List<Task>> get tasksStream => _tasksController.stream;
  set tasksStream(Stream<List<Task>> stream) => _tasksController.addStream(stream);



  //singleton pattern
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Check if the table exists
        var tableExists = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='$_tableName'");

        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT CHECK (LENGTH(name) >= 3),
            startTime TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert(_tableName, task.toMap());
    // After insertion, retrieve the updated list of tasks.
    //final tasks = await getTasks();
    // Add the updated list of tasks to the stream.
    //_tasksController.add(tasks);
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      offset: _offset, // Starting index
      limit: _limit,   // Number of tasks to retrieve
    );
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        name: maps[i]['name'],
        startTime: maps[i]['startTime'],
      );
    });
  }
  Future<void> updateNote(Task task) async {
    final db = await database;

    await db.update(
      _tableName,
      task.toMap(), // Converts the Note object to a map
      where: 'id = ?', // Condition to match the specific note by its ID
      whereArgs: [task.id], // Value to substitute into the WHERE clause
    );
  }
  Future<void> deleteTask(int id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?', // Condition to match the specific note by its ID
      whereArgs: [id], // Value to substitute into the WHERE clause
    );
  }
  Future<void> clear() async {
    final db = await database;
    if (db.isOpen) {
      await db.rawDelete('DELETE FROM $_tableName');
    } else {
      throw Exception('Database is not open');
    }
  }
}


