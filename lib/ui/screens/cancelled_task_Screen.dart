import 'package:flutter/material.dart';

import '../../models/new_task_model.dart';
import '../../network/network_caller.dart';
import '../../network/network_response.dart';
import '../../network/urls.dart';
import '../widgets/profileSummaryCard.dart';
import '../widgets/task_itemCard.dart';
import 'login_screen.dart';
class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  NewTaskModel newTaskModel = NewTaskModel();
  bool cancelTaskInProgress=false;
  bool deleteTaskInProgress=false;

  Future<void> fetchCancelTask() async {
    cancelTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.cancelTaskUrl);
    if (response.isSuccess) {
      newTaskModel = NewTaskModel.fromJson(response.jsonBody);
    } else if (response.statusCode == 401) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    }
    cancelTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    // log(newTaskModel.taskList!.length.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCancelTask();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: Visibility(
                visible: cancelTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                    itemCount: newTaskModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        chipColor: Colors.red,
                        task: newTaskModel.taskList![index],
                        refreshTask: fetchCancelTask,
                        inProgress: (isProgress) {
                          cancelTaskInProgress=isProgress;
                          if(mounted){
                            setState(() {

                            });
                          }
                        },

                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
