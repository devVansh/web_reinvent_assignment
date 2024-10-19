import 'package:get/get.dart';

class AppUtils {
  static void showSnackBar(String title, String message) {
    Get.snackbar(title, message);
  }
}
