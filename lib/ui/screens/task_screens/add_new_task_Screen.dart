import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/addNewTaskController.dart';
import 'package:task_manager_project/ui/screens/task_screens/bottom_nav_screen.dart';
import 'package:task_manager_project/ui/screens/user_verificationScreen/login_screen.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../../../service/bottom_nav_Controller.dart';
import '../../widgets/profileSummaryCard.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isCreateProgress = false;
  AddNewTaskController addNewTaskController = Get.find<AddNewTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          ProfileSummaryCard(),
          Expanded(
              child: BodyBackground(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 80,
                      ),
                      Text(
                        'Add New Task',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Title",
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Title!!!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                        validator: (String? value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'Enter a Description!!!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: GetBuilder<AddNewTaskController>(
                          builder: (addNewTaskController) {
                            return Visibility(
                              visible: addNewTaskController.isCreateProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: addNewTask,
                                child:
                                const Icon(Icons.arrow_circle_right_outlined),
                              ),
                            );
                          }
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    ));
  }

  Future<void> addNewTask() async {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
     final response = await addNewTaskController.addNewTask(titleController.text,descriptionController.text);
    if (response) {
      titleController.clear();
      descriptionController.clear();
      if (mounted) {
        showSnackBar(context, addNewTaskController.snackMessage);
      }
      Get.find<BottomNavController>().selectedIndex=0;
      Get.to(const BottomNavScreen());
    }
    else {
      if (mounted) {
        showSnackBar(context, addNewTaskController.snackMessage,true);
      }
      Get.offAll(const LoginScreen());
    }
  }
}
