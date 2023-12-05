import 'package:flutter/material.dart';
import 'package:task_manager_project/models/new_task_model.dart';
import '../../network/network_caller.dart';
import '../../network/network_response.dart';
import '../../network/urls.dart';
import '../widgets/profileSummaryCard.dart';
import '../widgets/task_itemCard.dart';
import 'login_screen.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  NewTaskModel newTaskModel = NewTaskModel();
  bool inProgressTaskInProgress = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInProgressTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: Visibility(
                visible: inProgressTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ListView.builder(
                    itemCount: newTaskModel.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                          chipColor: Colors.teal,
                          task: newTaskModel.taskList![index],
                          refreshTask: fetchInProgressTask,
                          inProgress: (isProgress) {
                            inProgressTaskInProgress = isProgress;
                            if (mounted) {
                              setState(() {});
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

  Future<void> fetchInProgressTask() async {
    inProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
        await NetworkCaller().getRequest(Urls.inProgressTaskUrl);
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
    inProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    // log(newTaskModel.taskList!.length.toString());
  }
}
