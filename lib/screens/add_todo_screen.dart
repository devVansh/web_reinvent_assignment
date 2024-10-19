import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_reinvent_assignment/get/controllers/todo_controller.dart';
import 'package:web_reinvent_assignment/utils/app_constants.dart';
import 'package:web_reinvent_assignment/utils/app_dimen.dart';

class AddToDoScreen extends GetView<ToDoController> {
  const AddToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          controller.headerText(),
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.all(AppDimen.dp8),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                children: <Widget>[
                  inputFieldWidget(
                      controller.titleController, AppConstants.addTitle,
                      validationMessage: AppConstants.titleValidation),
                  SizedBox(
                    height: AppDimen.dp10,
                  ),
                  inputFieldWidget(
                      controller.descController, AppConstants.addDescription,
                      validationMessage: AppConstants.descriptionValidation),
                  SizedBox(
                    height: AppDimen.dp10,
                  ),
                  inputFieldWidget(
                      controller.dateController, AppConstants.selectDate,
                      validationMessage: AppConstants.dateValidation,
                      isRead: true, callback: () {
                    controller.handleDatePicker();
                  }),
                  SizedBox(
                    height: AppDimen.dp18,
                  ),
                  ElevatedButton(
                      onPressed: () => controller.submit(),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width, Get.height * 0.06),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimen.dp6))),
                      child: Text(
                        controller.headerText(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimen.dp18,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputFieldWidget(
      TextEditingController textEditingController, String labelText,
      {TextStyle? textStyle,
      String? validationMessage,
      bool isRead = false,
      VoidCallback? callback}) {
    return TextFormField(
      controller: textEditingController,
      readOnly: isRead,
      onTap: () {
        if (callback != null) {
          callback.call();
        }
      },
      style: textStyle ?? TextStyle(fontSize: AppDimen.dp16),
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(horizontal: AppDimen.dp6),
        labelStyle: textStyle ?? TextStyle(fontSize: AppDimen.dp16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.dp6),
        ),
      ),
      validator: (input) => (input ?? "").trim().isEmpty
          ? validationMessage ?? 'Please enter valid text'
          : null,
    );
  }
}
