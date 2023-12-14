import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';

import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../network/urls.dart';

class DeleteTaskController extends GetxController {
  bool isLoading=false;
  Future<bool> deleteTask(String id) async {
    isLoading = true;
    update();
    NetworkResponse response = await NetworkCaller().getRequest(
        Urls.deleteTaskUrls(id.toString()));
    isLoading = false;
    update();
    log(response.statusCode.toString());
    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

}
