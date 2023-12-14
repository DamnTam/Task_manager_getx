import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/ui/screens/task_screens/bottom_nav_screen.dart';
import 'package:task_manager_project/ui/screens/user_verificationScreen/login_screen.dart';
import '../../service/authController.dart';
import '../widgets/body_background.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    goToLogin();
    super.initState();
  }

  goToLogin() async {
    bool isLoggedIn = await Get.find<AuthController>().checkAuthState();
    Future.delayed(const Duration(seconds: 7)).then((value) {
      Get.offAll(isLoggedIn ? const BottomNavScreen() : const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('asset/images/splash.json', width: 150),
              Text(
                'Task Manager',
                style: Theme.of(context).textTheme.titleLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}
