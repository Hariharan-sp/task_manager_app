import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class LocalDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "tasks.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE tasks (
         id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      customer TEXT,
      location TEXT,
      status TEXT,
      scheduledDate TEXT,
      startTime TEXT,
      endTime TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE timesheets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      taskId INTEGER,
      startTime TEXT,
      endTime TEXT,
      duration INTEGER,
      notes TEXT
    )
  ''');

    await db.execute('''
  CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
  )
''');

    await db.execute('''
  CREATE TABLE task_products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    taskId INTEGER,
    productId INTEGER,
    quantity INTEGER
  )
''');
  }

  static Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return maps.map((e) => TaskModel.fromMap(e)).toList();
  }

  static Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  // Get all products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }
}
