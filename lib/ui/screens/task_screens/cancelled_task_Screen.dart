import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/service/fetchTaskController.dart';
import '../../../network/urls.dart';
import '../../widgets/profileSummaryCard.dart';
import '../../widgets/task_itemCard.dart';
import 'package:get/get.dart';
import '../user_verificationScreen/login_screen.dart';
class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  FetchInTaskController fetchInTaskController = Get.find<FetchInTaskController>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCancelTask();
      
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<FetchInTaskController>(
                builder: (fetchInTaskController) {
                  return Visibility(
                    visible: fetchInTaskController.inProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                        itemCount: fetchInTaskController.newTaskModel.taskList
                            ?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FadeInLeftBig(
                            delay: const Duration(microseconds: 50),
                            child: TaskItemCard(
                              chipColor: Colors.red,
                              task: fetchInTaskController.newTaskModel.taskList![index],
                              refreshTask: fetchCancelTask,
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
  Future<void> fetchCancelTask() async {
    final response = await fetchInTaskController.fetchTask(Urls.cancelTaskUrl);
    if(response==false){
      Get.offAll(const LoginScreen());
    }
    // log(newTaskModel.taskList!.length.toString());
  }
}
