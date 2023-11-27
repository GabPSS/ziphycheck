import 'dart:convert';
import 'dart:developer';

import 'package:checkup_app/models/data_set.dart';
import 'package:sqflite/sqflite.dart';

class Storage {
  Database? _db;
  bool get isStarted => _db != null;

  Future<bool> init() async {
    try {
      _db = await openDatabase(
        'checkup_app.db',
        version: 1,
        onCreate: (db, version) {
          db.execute('CREATE TABLE datasets (dataset TEXT)');
        },
      );
      return true;
    } catch (e) {
      log('Failed to open storage');
      return false;
    }
  }

  Future<DataSet> getData([int index = 0]) async {
    if (!isStarted) if (!await init()) return DataSet();

    List<Map<String, Object?>>? list = await _db?.query('datasets');
    if (list == null || list.isEmpty) return DataSet();

    String? jsonString = list.elementAtOrNull(index)?['dataset'] as String?;
    if (jsonString == null) return DataSet();

    return DataSet.fromJson(jsonDecode(jsonString));
  }

  Future<void> save(DataSet dataset, [int index = 0]) async {
    if (!isStarted) if (!await init()) return;

    _db?.update('datasets', dataset.toJson());
  }
}
