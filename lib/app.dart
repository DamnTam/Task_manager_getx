import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/addNewTaskController.dart';
import 'package:task_manager_project/service/authController.dart';
import 'package:task_manager_project/service/bottom_nav_Controller.dart';
import 'package:task_manager_project/service/deleteTaskController.dart';
import 'package:task_manager_project/service/emailVerificationController.dart';
import 'package:task_manager_project/service/fetchTaskController.dart';
import 'package:task_manager_project/service/fetchTaskCountController.dart';
import 'package:task_manager_project/service/loginController.dart';
import 'package:task_manager_project/service/otpController.dart';
import 'package:task_manager_project/service/photoPickerController.dart';
import 'package:task_manager_project/service/resetPasswordController.dart';
import 'package:task_manager_project/service/signUpController.dart';
import 'package:task_manager_project/service/updateProfileController.dart';
import 'package:task_manager_project/service/updateTaskController.dart';
import 'package:task_manager_project/ui/screens/splash_screen.dart';
class DependencyBinder extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(LoginController());
    Get.put(SignUpController());
    Get.put(UpdateProfileController());
    Get.put(PhotoPickerController());
    Get.put(EmailVerificationController());
    Get.put(OtpController());
    Get.put(ResetPassWordController());
    Get.put(AuthController());
    Get.put(AddNewTaskController());
    Get.put(DeleteTaskController());
    Get.put(FetchInTaskController());
    Get.put(UpdateTaskController());
    Get.put(FetchTaskCountController());
    Get.put(BottomNavController());

  }

}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: DependencyBinder(),
      key: navigationKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black87,
            ),
          ),
        ),
        primaryColor: Colors.amber,
        primarySwatch: Colors.amber,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black
        ),
        floatingActionButtonTheme:  FloatingActionButtonThemeData(
          backgroundColor: Colors.amber.shade400,
          foregroundColor: Colors.black87,
          iconSize: 30,
          //add border to floating action button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.black87,width: 1.7),

          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.amber,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black87,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade400,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
