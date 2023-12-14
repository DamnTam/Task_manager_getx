import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/fetchTaskController.dart';
import '../../../network/urls.dart';
import '../../widgets/profileSummaryCard.dart';
import '../../widgets/task_itemCard.dart';
import '../user_verificationScreen/login_screen.dart';
class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  FetchInTaskController fetchInTaskController = Get.find<FetchInTaskController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCompleteTask();
    });

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const  ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<FetchInTaskController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress== false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                        itemCount: controller.newTaskModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FadeInLeftBig(
                            delay: const Duration(microseconds: 50 ),
                            child: TaskItemCard(
                              chipColor: Colors.green,
                              task: controller.newTaskModel.taskList![index],
                              refreshTask: fetchCompleteTask,
                            
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
  Future<void> fetchCompleteTask() async {

    final response = await fetchInTaskController.fetchTask(Urls.completeTaskUrl);
    if(response==false){
      Get.offAll(const LoginScreen());
    }
    // log(newTaskModel.taskList!.length.toString());
  }
}
