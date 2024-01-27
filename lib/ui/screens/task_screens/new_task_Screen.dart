import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/service/deleteTaskController.dart';
import 'package:task_manager_project/service/fetchTaskController.dart';
import 'package:task_manager_project/service/fetchTaskCountController.dart';
import 'package:task_manager_project/ui/screens/user_verificationScreen/login_screen.dart';
import '../../widgets/profileSummaryCard.dart';
import '../../widgets/summarycard.dart';
import '../../widgets/task_itemCard.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  FetchInTaskController fetchInTaskController= Get.find<FetchInTaskController>();
  FetchTaskCountController fetchTaskCountController = Get.find<FetchTaskCountController>();
  DeleteTaskController deleteTaskController=Get.find<DeleteTaskController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInTaskController.fetchTask(Urls.newTaskUrl);
      fetchTaskCountController.fetchTaskStatusCount();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            GetBuilder<FetchTaskCountController>(
              builder:(fetchTaskCountController) {
                return Visibility(
                    visible: fetchTaskCountController.taskStatusCountInProgress == false,
                    replacement: const LinearProgressIndicator(),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: fetchTaskCountController
                              .taskStatusCountModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return FittedBox(
                              child: SummaryCard(
                                  title: fetchTaskCountController
                                      .taskStatusCountModel.data?[index].sum
                                      .toString() ?? '',
                                  count: fetchTaskCountController
                                      .taskStatusCountModel.data?[index].sId
                                      .toString() ?? ''),
                            );
                          }),
                    ));
              }
            ),
            Expanded(
              child: GetBuilder<FetchInTaskController>(
                builder: (fetchInTaskController) {
                  return Visibility(
                    visible:  fetchInTaskController.inProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                        itemCount: fetchInTaskController.newTaskModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FadeInLeftBig(
                            delay: const Duration(microseconds: 50),
                            child: TaskItemCard(
                              chipColor: Colors.blue,
                              task: fetchInTaskController.newTaskModel.taskList![index],
                              refreshTask: fetchNewTask,
                              refreshSummary: fetchTaskStatusCount,
                            ),
                          );
                        }),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> fetchNewTask() async {

    final response =await fetchInTaskController.fetchTask(Urls.newTaskUrl);
    if(response==false){
      Get.offAll(const LoginScreen());
    }

    // log(newTaskModel.taskList!.length.toString());
  }
  Future<void> fetchTaskStatusCount() async {
    final response = await fetchTaskCountController.fetchTaskStatusCount();
    if(response==false){
      Get.offAll(const LoginScreen());
    }

    // log(newTaskModel.taskList!.length.toString());
  }
}
 