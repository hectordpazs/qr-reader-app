import 'package:flutter/material.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel?> scans = [];
  String typeSelected = 'http';

  Future<ScanModel?> newScan(String value) async {
    final newScan = ScanModel(valor: value);
    final id = await DBProvider.db.nuevoScan(newScan);
    //asignar el ID de la bdd al modelo
    newScan.id = id;

    if (typeSelected == newScan.tipo) {
      scans.add(newScan);
      notifyListeners();
    }

    return newScan;
  }

  getScans() async {
    final allScans = await DBProvider.db.getAllScans();
    scans = [...allScans];
    notifyListeners();
  }

  getScansPerType(String type) async {
    final scansPerType = await DBProvider.db.getScansPerType(type);
    scans = [...scansPerType];
    typeSelected = type;
    notifyListeners();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  deleteScansPerId(int? id) async {
    await DBProvider.db.deleteScan(id);
    getScansPerType(typeSelected);

    //scans = [...scans.map((e) => e?.id != id ? e : null)];
    /*scans = [...scans.where(
      (element) {
        return element?.id != id;
      }
    )];
    notifyListeners();*/
  }
}
