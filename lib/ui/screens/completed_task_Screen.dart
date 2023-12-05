import 'package:flutter/material.dart';

import '../../models/new_task_model.dart';
import '../../network/network_caller.dart';
import '../../network/network_response.dart';
import '../../network/urls.dart';
import '../widgets/profileSummaryCard.dart';
import '../widgets/task_itemCard.dart';
import 'login_screen.dart';
class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  NewTaskModel newTaskModel = NewTaskModel();
  bool completeTaskInProgress=false;

  Future<void> fetchCompleteTask() async {
    completeTaskInProgress=true;
    if(mounted){
      setState(() {

      });
    }
    NetworkResponse response =
    await NetworkCaller().getRequest(Urls.completeTaskUrl);
    if (response.isSuccess) {
      newTaskModel = NewTaskModel.fromJson(response.jsonBody);
    }
    else if (response.statusCode == 401) {
      if(mounted){
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()), (
            route) => false);
      }
    }
    completeTaskInProgress=false;
    if (mounted) {
      setState(() {});
    }
    // log(newTaskModel.taskList!.length.toString());
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCompleteTask();
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
                visible: completeTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                    itemCount: newTaskModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        chipColor: Colors.green,
                        task: newTaskModel.taskList![index],
                        refreshTask: fetchCompleteTask,
                        inProgress: (isProgress) {
                          completeTaskInProgress=isProgress;
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
