import 'dart:async';

import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "favorite.db";
  static const _databaseVersion = 1;
  static const _favoriteTable = "FAVORITE";
  static const _columnId = "id";
  static const _columnPath = "PATH";
  static const _columnDisplayName = "DISPLAYNAME";
  static const _columnAlbum = "ALBUM";
  static const _columnAlbumImage = "ALBUMIMAGE";
  static const _columnArtist = "ARTIST";
  static const _columnDateAdded = "ADDEDAT";
  static const _columnSize = "SIZE";
  static const _columnDuration = "DURATION";

  DatabaseHelper._privateContructor();
  static final DatabaseHelper instance = DatabaseHelper._privateContructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<void> insertSongToFavorite(SongInfo song) async {
    Database? db = await instance.database;
    int result = await db!.insert(_favoriteTable, {
      _columnPath: song.filePath,
      _columnDisplayName: song.displayName,
      _columnArtist: song.artist,
    });
    print(result);
  }

  Future<void> deleteSongFromFavorite(SongInfo song) async {
    Database? db = await instance.database;
    int result = await db!.delete(
      _favoriteTable,
      where:
          "$_columnPath = ? AND $_columnDisplayName = ? AND $_columnArtist = ?",
      whereArgs: [song.filePath, song.displayName, song.artist],
    );
  }

  Future<List<Map<String, Object?>>> songIsFavorite(SongInfo song) async {
    Database? db = await instance.database;
    List<Map<String, Object?>> res = await db!.query(_favoriteTable,
        where:
            "$_columnPath = ? AND $_columnDisplayName = ? AND $_columnArtist = ?",
        whereArgs: [song.filePath, song.displayName, song.artist]);
    print(res);
    return res;
  }

  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath() + _databaseName;
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_favoriteTable (
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

  Future<void> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    await db!.insert(_favoriteTable, row);
  }

  Future<List<Map<String, dynamic>>> querryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(_favoriteTable);
  }
}
