import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_reinvent_assignment/get/controllers/todo_controller.dart';
import 'package:web_reinvent_assignment/model/todo_model.dart';
import 'package:web_reinvent_assignment/utils/app_constants.dart';

import '../utils/app_dimen.dart';

class CompletedTodoScreen extends GetView<ToDoController> {
  const CompletedTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppConstants.completedTitle),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: controller.completedList.stream,
        builder: (context, snapshot) {
          if ((snapshot.data ?? []).isEmpty) {
            return Center(
              child: Text(AppConstants.noTodoCompleted),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            itemCount: (snapshot.data ?? []).length,
            itemBuilder: (BuildContext context, int index) {
              return _buildToDo(context, (snapshot.data ?? [])[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildToDo(BuildContext context, TodoListModel todoListModel) {
    return Container(
      margin: EdgeInsets.all(AppDimen.dp12),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                blurRadius: AppDimen.dp2,
                spreadRadius: AppDimen.dp2),
          ],
          borderRadius: BorderRadius.circular(AppDimen.dp6)),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              todoListModel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppDimen.dp18,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoListModel.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppDimen.dp14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  controller.dateFormatter.format(todoListModel.date),
                  style: TextStyle(
                    fontSize: AppDimen.dp14,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            contentPadding: EdgeInsets.symmetric(horizontal: AppDimen.dp6),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.restore,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () {
                    controller.markIncomplete(todoListModel);
                  },
                ),
                SizedBox(
                  width: AppDimen.dp14,
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onTap: () {
                    controller.deleteTask(todoListModel.id);
                  },
                ),
              ],
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }
}
