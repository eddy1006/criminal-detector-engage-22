import 'dart:io';

import 'package:face_net_authentication/pages/models/criminal.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 5;

  static final table = 'criminals';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnAge = 'age';
  static final columnIdentification = 'identification';
  static final columnThreat = 'threat';
  static final columnModelData = 'model_data';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge TEXT NOT NULL,
            $columnIdentification TEXT NOT NULL,
            $columnThreat TEXT NOT NULL,
            $columnModelData TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(Criminal user) async {
    Database db = await instance.database;
    return await db.insert(table, user.toMap());
  }

  Future<List<Criminal>> queryAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(table);
    return users.map((u) => Criminal.fromMap(u)).toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
