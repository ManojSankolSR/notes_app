import 'package:bottom/Models/DataModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

Future<Database> _getdatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbpath, 'Note.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE Note(Id TEXT PRIMARY KEY,Date TEXT,Title TEXT,Note TEXT)');
  }, version: 3);
  return db;
}

class DataBaseNotifier extends StateNotifier<List<DataModel>> {
  DataBaseNotifier() : super(const []);

  void addNote(DataModel Note) async {
    final db = await _getdatabase();
    db.insert('Note', {
      'Id': Note.id,
      'Date': Note.date.toString(),
      'Title': Note.title,
      'Note': Note.note,
    });
    state = [Note, ...state];
  }

  Future<DataModel> delete(DataModel Note) async {
    final db = await _getdatabase();
     await db.delete('Note', where: 'Id=?', whereArgs: [
        Note.id,
      ]);
    int ind = state.indexOf(Note);
    final delNote = state.removeAt(ind);
    state = [...state];
    return delNote;
  }

  void update(String note, String title, String id) async {
    final db = await _getdatabase();
    await db.update(
        'Note',
        {
          'Id': id,
          'Date': DateTime.now().toString(),
          'Title': title,
          'Note': note,
        },
        where: 'Id=?',
        whereArgs: [id]);
    getData();
  }

  void getData() async {
    final db = await _getdatabase();
    final data = await db.query('Note');
    final dataList = data
        .map((row) => DataModel(
            id: row['Id'] as String,
            date: DateTime.parse(row['Date'] as String),
            title: row['Title'] as String,
            note: row['Note'] as String))
        .toList();
    state = dataList;
    print(data);
  }
}

final DataBaseProvider =
    StateNotifierProvider<DataBaseNotifier, List<DataModel>>(
        (ref) => DataBaseNotifier());
