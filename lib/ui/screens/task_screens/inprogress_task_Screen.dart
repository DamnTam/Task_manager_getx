import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/service/fetchTaskController.dart';
import 'package:task_manager_project/ui/screens/user_verificationScreen/login_screen.dart';
import '../../widgets/profileSummaryCard.dart';
import '../../widgets/task_itemCard.dart';
import 'package:get/get.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  FetchInTaskController fetchInTaskProgressController=Get.find<FetchInTaskController>();


  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInProgressTask();
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             const ProfileSummaryCard(),
            Expanded(
              child: GetBuilder<FetchInTaskController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                        itemCount: controller.newTaskModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FadeInLeftBig(
                            delay:const Duration(microseconds: 50 ),
                            child: TaskItemCard(
                              chipColor: Colors.teal,
                              task: controller.newTaskModel.taskList![index],
                              refreshTask: fetchInProgressTask,
                            
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

  Future<void> fetchInProgressTask() async {
   final response =await fetchInTaskProgressController.fetchTask(Urls.inProgressTaskUrl);
   if(response==false){
     Get.offAll(const LoginScreen());
   }
    // log(newTaskModel.taskList!.length.toString());
  }
}
