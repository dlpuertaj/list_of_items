import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'app_database.db');
    print('Database path: $path');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print('Creating records table...');
    await db.execute('''
      CREATE TABLE records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT NOT NULL,
        text TEXT NOT NULL,
        record_note TEXT
      )
    ''');
    print('Records table created.');
  }

  // Insert a new record
  Future<int> insertRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    print('Inserting record: $row');
    int id = await db.insert('records', row);
    print('Inserted record with id: $id');
    return id;
  }

  // Get all records
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    Database db = await instance.database;
    print('Fetching all records...');
    final result = await db.query('records', orderBy: 'id DESC');
    print('Fetched ${result.length} records.');
    return result;
  }

  // Update a record by id
  Future<int> updateRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    print('Updating record id $id: $row');
    int count = await db.update(
      'records',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Updated $count record(s).');
    return count;
  }

  // Delete a record by id
  Future<int> deleteRecord(int id) async {
    Database db = await instance.database;
    print('Deleting record id $id');
    int count = await db.delete('records', where: 'id = ?', whereArgs: [id]);
    print('Deleted $count record(s).');
    return count;
  }
}
