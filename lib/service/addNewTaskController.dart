import 'dart:developer';
import 'package:get/get.dart';
import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../network/urls.dart';

class AddNewTaskController extends GetxController{
  bool _isCreateProgress=false;
  String _snackMessage='';
  bool get isCreateProgress=> _isCreateProgress;
  String get snackMessage=>_snackMessage;
  Future<bool> addNewTask(String title,description) async {
    _isCreateProgress = true;
    update();
    NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTaskUrl, body: {
      "title": title,
      "description": description,
      "status": "New"
    });
    _isCreateProgress = false;
    update();
    log(response.jsonBody.toString());
    if (response.isSuccess) {
      _snackMessage='Successfull';
      return true;

     // Get.offAll(const BottomNavScreen());
    } else {
      _snackMessage='Task add Failed';
     // Get.offAll(const LoginScreen());
    }
    return false;
  }

}