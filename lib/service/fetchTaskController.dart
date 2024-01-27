import 'package:get/get.dart';
import 'package:task_manager_project/models/new_task_model.dart';

import '../network/network_caller.dart';
import '../network/network_response.dart';


class FetchInTaskController extends GetxController{
  NewTaskModel newTaskModel=NewTaskModel();
  bool inProgress=false;
  Future<bool> fetchTask(String url) async {
    inProgress = true;
    update();
    NetworkResponse response = await NetworkCaller().getRequest(url);
    inProgress = false;
    update();
    if (response.isSuccess) {
      newTaskModel = NewTaskModel.fromJson(response.jsonBody);
      return true;
    }
    else if(response.statusCode==401){
      return false;
    }

    return false;
    // log(newTaskModel.taskList!.length.toString());
  }
}


