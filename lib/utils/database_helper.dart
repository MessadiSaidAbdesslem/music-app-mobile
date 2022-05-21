import 'dart:async';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "favorite.db";
  static final _databaseVersion = 1;
  static final _favorite_table = "FAVORITE";
  static final _columnId = "id";
  static final _columnPath = "PATH";
  static final _columnDisplayName = "DISPLAYNAME";
  static final _columnAlbum = "ALBUM";
  static final _columnAlbumImage = "ALBUMIMAGE";
  static final _columnArtist = "ARTIST";
  static final _columnDateAdded = "ADDEDAT";
  static final _columnSize = "SIZE";
  static final _columnDuration = "DURATION";

  DatabaseHelper._privateContructor();
  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath() + _databaseName;
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_favorite_table (
      $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $_columnPath TEXT,
      $_columnDisplayName TEXT,
      $_columnAlbum TEXT,
      $_columnAlbumImage TEXT,
      $_columnArtist TEXT,
      $_columnDateAdded TEXT,
      $_columnSize TEXT,
      $_columnDuration TEXT
    )
''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(_favorite_table, row);
  }

  Future<List<Map<String, dynamic>>> querryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(_favorite_table);
  }
}
