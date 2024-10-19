import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_reinvent_assignment/get/controllers/todo_controller.dart';
import 'package:web_reinvent_assignment/model/todo_model.dart';
import 'package:web_reinvent_assignment/utils/app_constants.dart';
import 'package:web_reinvent_assignment/utils/app_dimen.dart';

class HomeScreen extends GetView<ToDoController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppConstants.title),
        titleSpacing: AppDimen.dp8,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(Get.width, Get.height * 0.03),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppDimen.dp10, vertical: AppDimen.dp10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppConstants.pendingTasks,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: AppDimen.dp18),
                ),
                GestureDetector(
                  onTap: () => controller.navigateToCompleted(),
                  child: Text(
                    AppConstants.viewCompleted,
                    style: TextStyle(fontSize: AppDimen.dp14),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (controller.toDoList().isNotEmpty)
            IconButton(
                icon: Text(
                  AppConstants.clearAll,
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: () => controller.deleteAll()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.navigateToAddTask(),
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: controller.toDoList.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<TodoListModel> todoList = snapshot.data as List<TodoListModel>;
          final int taskCount = todoList
              .where((TodoListModel task) => task.status == 0)
              .toList()
              .length;
          if (taskCount == 0) {
            return Center(
              child: Text(AppConstants.noTodoAdded),
            );
          }
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildToDo(context, todoList[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildToDo(BuildContext context, TodoListModel todoListModel) {
    if (todoListModel.status != 0) {
      return const SizedBox.shrink();
    }
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
      child: ListTile(
        title: Text(
          todoListModel.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: AppDimen.dp18,
            fontWeight: FontWeight.bold,
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
              ),
            ),
            Text(
              controller.dateFormatter.format(todoListModel.date),
              style: TextStyle(
                fontSize: AppDimen.dp14,
              ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Checkbox(
          onChanged: (value) {
            controller.markComplete(todoListModel);
          },
          activeColor: Theme.of(context).primaryColor,
          value: todoListModel.status == 1 ? true : false,
        ),
        onTap: () {
          controller.navigateToUpdate(todoListModel);
        },
      ),
    );
  }
}
