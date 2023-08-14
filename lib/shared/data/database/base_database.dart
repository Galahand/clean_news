import 'package:sqflite/sqflite.dart';

class BaseDatabase {
  BaseDatabase(this.databaseName, this.onDatabaseCreation);

  final String databaseName;
  final Future<void> Function(Database database, int version)?
      onDatabaseCreation;

  Database? _database;

  Future<Database> get database async {
    var result = _database;

    if (result != null && result.isOpen) return result;

    result = await open();
    _database = result;

    return result;
  }

  Future<Database> open() async {
    return openDatabase(databaseName, version: 1, onCreate: onDatabaseCreation);
  }

  Future<int> insert(String table, Map<String, dynamic> values) {
    return database.then((value) => value.insert(table, values));
  }

  Future<List<Map<String, dynamic>>> query(String table) {
    return database.then((value) => value.query(table));
  }

  Future<void> close() async {
    await _database?.close();
  }
}
