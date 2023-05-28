// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:inex/model/dbhelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database!;

    // If database don't exists, create one
    _database = await initDB();

    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'incomeExpense_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Accounts('
          'id INTEGER PRIMARY KEY,'
          'date TEXT,'
          'name TEXT,'
          'income TEXT,'
          'expense TEXT,'
          'type TEXT,'
          'description TEXT'
          ')');
    });
  }

  //create denomination
  createDenomination(Expense denomination) async {
    //await deleteAllDenomination();
    final db = await database;
    final res = await db.insert('Accounts', denomination.toJson());

    return res;
  }

  // Delete all denomination
  Future<int> deleteAllDenomination() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Accounts');

    return res;
  }
  //delete perticular denominati on

  deletePersonWithId(int id) async {
    final db = await database;
    return db.delete("Accounts", where: "id = ?", whereArgs: [id]);
  }

  updatePerson(Expense person) async {
    final db = await database;
    var response = await db.update("Accounts", person.toJson(),
        where: "id = ?", whereArgs: [person.id]);
    return response;
  }

  //get denomination
  Future<List<Expense>> getAllDenomination() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM accounts");

    List<Expense> list =
        res.isNotEmpty ? res.map((c) => Expense.fromJson(c)).toList() : [];

    return list;
  }
}
