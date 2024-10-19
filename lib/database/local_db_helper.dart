import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:web_reinvent_assignment/model/todo_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String toDoListTable = 'todo_list_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDesc = 'description';
  String colDate = 'date';
  String colStatus = 'status';

  Future<Database> get db async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/todo_list.db';
    final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $toDoListTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,$colDesc TEXT, $colDate TEXT, $colStatus INTEGER)',
    );
  }

  Future<List<Map<String, dynamic>>> getToDoMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(toDoListTable);
    return result;
  }

  Future<List<TodoListModel>> getToDoList() async {
    final List<Map<String, dynamic>> toDoMapList = await getToDoMapList();
    final List<TodoListModel> todoList = [];
    for (var todoMap in toDoMapList) {
      todoList.add(TodoListModel.fromJson(todoMap));
    }
    todoList.sort((todoA, todoB) => todoA.date.compareTo(todoB.date));
    return todoList;
  }

  Future<List<TodoListModel>> getCompletedToDoList() async {
    final List<Map<String, dynamic>> toDoMapList = await getToDoMapList();
    final List<TodoListModel> todoList = [];
    for (var todoMap in toDoMapList) {
      todoList.add(TodoListModel.fromJson(todoMap));
    }
    todoList.sort((todoA, todoB) => todoA.date.compareTo(todoB.date));
    return todoList.where((element) => element.status == 1).toList();
  }

  Future<int> insertToDo(TodoListModel todo) async {
    Database db = await this.db;
    final int result = await db.insert(toDoListTable, todo.toJson());
    return result;
  }

  Future<int> updateToDo(TodoListModel todo) async {
    Database db = await this.db;
    final int result = await db.update(
      toDoListTable,
      todo.toJson(),
      where: '$colId = ?',
      whereArgs: [todo.id],
    );
    return result;
  }

  Future<int> deleteToDo(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      toDoListTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteAllToDo() async {
    Database db = await this.db;
    final int result = await db.delete(toDoListTable);
    return result;
  }
}
