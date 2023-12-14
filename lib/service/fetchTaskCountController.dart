import 'package:get/get.dart';
import 'package:task_manager_project/models/task_status_count_model.dart';

import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../network/urls.dart';

class FetchTaskCountController extends GetxController{
  TaskStatusCountModel taskStatusCountModel =TaskStatusCountModel();
  bool taskStatusCountInProgress=false;
  Future<bool> fetchTaskStatusCount() async {
    taskStatusCountInProgress = true;
    update();
    NetworkResponse response =
    await NetworkCaller().getRequest(Urls.taskStatusCountUrls);
    taskStatusCountInProgress = false;
    update();
    if (response.isSuccess) {

      taskStatusCountModel = TaskStatusCountModel.fromJson(response.jsonBody);
      return true;
    }
    return false;
    // log(newTaskModel.taskList!.length.toString());
  }
}