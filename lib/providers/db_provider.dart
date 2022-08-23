import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    //Path de donde almacenare la BDD!!!
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //esto me da el path unos numeros ahi

    final path = join(documentsDirectory.path, 'ScansDB.db');
    //crear BDD

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipo TEXT,
          valor TEXT
        )
      ''');
    });
  }

  Future<int?> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //verify DB
    final db = await database;

    final res = await db?.rawInsert('''
      INSERT INTO Scans(id, tipo, valor)
        VALUES($id, '$tipo', '$valor')
    ''');

    return res;
  }

  Future<int?> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db?.insert('Scans', nuevoScan.toMap());

    //id del ultimo registro insertado
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;
    final res = await db?.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res!.isNotEmpty ? ScanModel.fromMap(res.first) : null;
  }

  Future<List<ScanModel?>> getAllScans() async {
    final db = await database;
    final res = await db?.query('Scans');

    return res!.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<List<ScanModel?>> getScansPerType(String type) async {
    final db = await database;
    final res = await db?.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$type'
    ''');

    return res!.isNotEmpty ? res.map((e) => ScanModel.fromMap(e)).toList() : [];
  }

  Future<int?> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = await db?.update('Scans', newScan.toMap(),
      where: 'id = ?', whereArgs: [newScan.id]);

    return res;
  }

  Future<int?> deleteScan(int? id) async {
    final db = await database;
    final res = await db?.delete('Scans',
      where: 'id = ?', whereArgs: [id]);
      
    return res;
  }

  Future<int?> deleteAllScans() async {
    final db = await database;
    final res = await db?.delete('Scans');
      
    return res;
  }
}
