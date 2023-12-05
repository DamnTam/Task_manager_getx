import 'package:flutter/material.dart';
import 'package:task_manager_project/models/new_task_model.dart';
import 'package:task_manager_project/models/task_status_count_model.dart';
import 'package:task_manager_project/network/network_caller.dart';
import 'package:task_manager_project/network/network_response.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/ui/screens/login_screen.dart';
import '../widgets/profileSummaryCard.dart';
import '../widgets/summarycard.dart';
import '../widgets/task_itemCard.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  NewTaskModel newTaskModel = NewTaskModel();
  TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel();
  bool newTaskInProgress = false;
  bool taskStatusCountInProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    fetchNewTask();
    fetchTaskStatusCount();
    super.initState();
  }

  Future<void> fetchTaskStatusCount() async {
    taskStatusCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller().getRequest(Urls.taskStatusCountUrls);
    if (response.isSuccess) {
      taskStatusCountModel = TaskStatusCountModel.fromJson(response.jsonBody);
    }
    taskStatusCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
    // log(newTaskModel.taskList!.length.toString());
  }

  Future<void> fetchNewTask() async {
    newTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller().getRequest(Urls.newTaskUrl);
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
    newTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    // log(newTaskModel.taskList!.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Visibility(
                visible: taskStatusCountInProgress == false,
                replacement: const LinearProgressIndicator(),
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: taskStatusCountModel.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return FittedBox(
                          child: SummaryCard(
                              title: taskStatusCountModel.data?[index].sum
                                  .toString() ?? '',
                              count: taskStatusCountModel.data?[index].sId
                                  .toString() ?? ''),
                        );
                      }),
                )),
            Expanded(
              child: Visibility(
                visible: newTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: ()async{
                     fetchNewTask();
                     fetchTaskStatusCount();
                  },
                  child: ListView.builder(
                      itemCount: newTaskModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          chipColor: Colors.blue,
                          task: newTaskModel.taskList![index],
                          refreshTask: fetchNewTask,
                          refreshSummary: fetchTaskStatusCount,
                          inProgress: (isProgress) {
                            newTaskInProgress = isProgress;
                            taskStatusCountInProgress = isProgress;
                            if (mounted) {
                              setState(() {});
                            }
                          },


                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
