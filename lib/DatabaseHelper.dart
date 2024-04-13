import 'dart:async';
import 'package:BiNotes/Catatan.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    String path = join(await getDatabasesPath(), 'catatan_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE catatan(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT,
      isi TEXT,
      waktu TEXT
    )''');
  }

  void tambahCatatan(Catatan catatan) async {
    int id = await DatabaseHelper.instance.insertCatatan(catatan);
    print('Catatan baru ditambahkan dengan ID: $id');
  }

  Future<int> insertCatatan(Catatan catatan) async {
    Database db = await instance.database;
    return await db.insert('catatan', catatan.toMap());
  }

  Future<List<Catatan>> getCatatanList() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> catatanMaps = await db.query('catatan');
      return List.generate(catatanMaps.length, (index) {
        return Catatan(
          id: catatanMaps[index]['id'],
          judul: catatanMaps[index]['judul'],
          isi: catatanMaps[index]['isi'],
          waktu: catatanMaps[index]['waktu'],
        );
      });
    } catch (e) {
      print("Error while fetching catatan: $e");
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  Future<int> getLastCatatanId() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(id) as last_id FROM catatan');
    int lastId = result.first['last_id'] ?? 0;
    return lastId;
  }

  Future<Catatan?> getCatatanById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Catatan(
        id: maps[0]['id'],
        judul: maps[0]['judul'],
        isi: maps[0]['isi'],
        waktu: maps[0]['waktu'],
      );
    } else {
      return null;
    }
  }

  Future<void> updateCatatan(Catatan catatan) async {
    Database db = await instance.database;
    await db.update(
      'catatan',
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
  }

  Future<void> deleteCatatan(int id) async {
    final db = await instance.database;
    await db.delete(
      'catatan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
