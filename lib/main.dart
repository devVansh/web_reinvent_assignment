import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_reinvent_assignment/get/bindings/todo_binding.dart';
import 'package:web_reinvent_assignment/routes/app_pages_constants.dart';
import 'package:web_reinvent_assignment/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WebReinvent Assignment',
      debugShowCheckedModeBanner: kDebugMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: ToDoBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.list,
    );
  }
}
