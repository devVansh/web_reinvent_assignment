import 'package:get/get.dart';
import 'package:web_reinvent_assignment/get/controllers/todo_controller.dart';

class ToDoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ToDoController>(() => ToDoController());
  }
}
