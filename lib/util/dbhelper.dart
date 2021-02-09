import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_demo/models/Todo.dart';

class DbHelper {
  static final DbHelper dbHelper = DbHelper._interval();
  String tblTodo = 'todo';
  String colID = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';

  DbHelper._interval();

  factory DbHelper() {
    return dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) _db = await initilizeDb();
    return _db;
  }

  Future<Database> initilizeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'todos.db';
    var toDoDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return toDoDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(''
        'create table $tblTodo($colID integer primary key, $colTitle text, $colDescription text, $colDate text, $colPriority integer);');
  }

  Future<int> insert(Todo todo) async {
    Database db = await this.db;
    var result = await db.insert(tblTodo,todo.toMap());
    return result;
  }

  Future<List> getListTodos() async{
    Database db = await this.db;
    var result = await db.rawQuery('select * from $tblTodo order by $colPriority asc');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
      await db.rawQuery('select count(*) from $tblTodo')
    );
    return result;
  }

  Future<int> update(Todo todo) async{
    Database db = await this.db;
    var result = await db.update(tblTodo, todo.toMap(),where: "$colID = ?",whereArgs: [todo.id]);
    return result;
  }


 Future<int> delete(Todo todo) async{
    Database db = await this.db;
    var result = await db.delete(tblTodo,where: "$colID = ?",whereArgs: [todo.id]);
    return result;
  }


}
