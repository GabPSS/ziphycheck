import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:checkup_app/models/data_set.dart';
import 'package:file_picker/file_picker.dart';
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
      log('Storage opened');
      return true;
    } catch (e) {
      log('Failed to open storage');
      return false;
    }
  }

  Future<DataSet> getData([int index = 0]) async {
    log('Fetching data');
    if (!isStarted) if (!await init()) return DataSet();

    List<Map<String, Object?>>? list = await _db?.query('datasets');
    if (list == null || list.isEmpty) {
      log('No datasets, creating new dataset');
      await _db?.insert('datasets', {'dataset': '{}'});
      return DataSet();
    }

    String? jsonString = list.elementAtOrNull(index)?['dataset'] as String?;
    if (jsonString == null) return DataSet();

    log('Decoding data');
    return DataSet.fromJson(jsonDecode(jsonString));
  }

  Future<DataSet?> open() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.length == 1) {
      String jsonString;
      jsonString = utf8.decode(result.files.single.bytes ?? []);
      return DataSet.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future<void> save(DataSet dataset, [int index = 0]) async {
    if (!isStarted) if (!await init()) return;
    log('Saving data');
    _db?.update('datasets', {'dataset': jsonEncode(dataset.toJson())});
  }

  Future<void> saveToPath(String path, String json) async {
    await File(path).writeAsString(json, flush: true);
  }
}
