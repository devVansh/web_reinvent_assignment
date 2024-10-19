import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:web_reinvent_assignment/model/todo_model.dart';
import 'package:web_reinvent_assignment/routes/app_pages_constants.dart';
import 'package:web_reinvent_assignment/utils/app_constants.dart';
import 'package:web_reinvent_assignment/utils/app_utils.dart';

import '../../database/local_db_helper.dart';

class ToDoController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var dateController = TextEditingController();
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var titleFocus = FocusNode();
  var descFocus = FocusNode();
  final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');
  Rx<DateTime> initialDate = DateTime.now().obs;

  Rx<List<TodoListModel>> toDoList = Rx<List<TodoListModel>>([]);
  Rx<List<TodoListModel>> completedList = Rx<List<TodoListModel>>([]);

  Rxn<TodoListModel> selectedTodo = Rxn<TodoListModel>();

  String headerText() =>
      selectedTodo() != null ? AppConstants.upDateToDo : AppConstants.addTodo;

  @override
  void onInit() {
    super.onInit();
    fetchTodoList();
  }

  Future<void> fetchTodoList() async {
    toDoList.value = await DatabaseHelper.instance.getToDoList();
    update();
  }

  Future<void> fetchCompletedTodoList() async {
    completedList.value = await DatabaseHelper.instance.getCompletedToDoList();
    update();
  }

  navigateToAddTask() {
    Get.toNamed(AppRoutes.addTodo);
  }

  navigateToCompleted() {
    fetchCompletedTodoList();
    Get.toNamed(AppRoutes.completedTodo);
  }

  navigateToUpdate(TodoListModel todoListModel) {
    Get.toNamed(AppRoutes.addTodo);
    titleController.text = todoListModel.title;
    descController.text = todoListModel.description;
    dateController.text = dateFormatter.format(todoListModel.date);
    selectedTodo(todoListModel);
  }

  handleDatePicker() async {
    unFocusControllers();
    final DateTime? date = await showDatePicker(
      context: Get.overlayContext!,
      initialDate: initialDate(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null && date != initialDate()) {
      initialDate(date);

      dateController.text = dateFormatter.format(date);
    }
  }

  submit() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      TodoListModel task = TodoListModel(
          title: titleController.text,
          date: initialDate(),
          description: descController.text);
      if (selectedTodo() == null) {
        task.status = 0;
        await DatabaseHelper.instance.insertToDo(task);
        Get.back();
        AppUtils.showSnackBar(
            AppConstants.todoAdded, AppConstants.todoAddedDesc);
      } else {
        task.status = selectedTodo()?.status;
        task.id = selectedTodo()?.id;
        await DatabaseHelper.instance.updateToDo(task);

        Get.back();
        AppUtils.showSnackBar(
            AppConstants.todoUpdated, AppConstants.todoUpdatedDesc);
      }
      clearUpdatedValues();
      fetchTodoList();
    }
  }

  Future<void> markComplete(TodoListModel todoListModel) async {
    todoListModel.status = 1;
    await DatabaseHelper.instance.updateToDo(todoListModel);
    fetchTodoList();
    fetchCompletedTodoList();
    AppUtils.showSnackBar(AppConstants.completed, AppConstants.completedDesc);
  }

  Future<void> markIncomplete(TodoListModel todoListModel) async {
    todoListModel.status = 0;
    await DatabaseHelper.instance.updateToDo(todoListModel);
    AppUtils.showSnackBar(AppConstants.retrieve, AppConstants.retrieveDesc);
    fetchTodoList();
    fetchCompletedTodoList();
  }

  clearUpdatedValues() {
    selectedTodo(null);
    titleController.clear();
    descController.clear();
    dateController.clear();
    unFocusControllers();
  }

  unFocusControllers() {
    titleFocus.unfocus();
    descFocus.unfocus();
  }

  deleteAll() async {
    await DatabaseHelper.instance.deleteAllToDo();
    AppUtils.showSnackBar(
        AppConstants.allTodoDeleted, AppConstants.allTodoDeletedDesc);
    fetchTodoList();
  }

  deleteTask(int? id) async {
    if (id == null) return;
    await DatabaseHelper.instance.deleteToDo(id);
    AppUtils.showSnackBar(
        AppConstants.allTodoDeleted, AppConstants.todoDeletedDesc);
    fetchCompletedTodoList();
  }
}
