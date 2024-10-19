// To parse this JSON data, do
//
//     final todoListModel = todoListModelFromJson(jsonString);

import 'dart:convert';

TodoListModel todoListModelFromJson(String str) =>
    TodoListModel.fromJson(json.decode(str));

String todoListModelToJson(TodoListModel data) => json.encode(data.toJson());

class TodoListModel {
  int? id;
  String title;
  String description;
  DateTime date;
  int? status;

  TodoListModel({
    this.id,
    required this.title,
    required this.date,
    required this.description,
    this.status,
  });

  factory TodoListModel.fromJson(Map<String, dynamic> json) => TodoListModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}
