import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:web_reinvent_assignment/get/bindings/todo_binding.dart';
import 'package:web_reinvent_assignment/screens/home_screen.dart';

import '../screens/add_todo_screen.dart';
import '../screens/completed_screen.dart';
import 'app_pages_constants.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: ToDoBinding(),
    ),
    GetPage(
      name: AppRoutes.addTodo,
      page: () => const AddToDoScreen(),
      binding: ToDoBinding(),
    ),
    GetPage(
      name: AppRoutes.completedTodo,
      page: () => const CompletedTodoScreen(),
      binding: ToDoBinding(),
    ),
  ];
}
