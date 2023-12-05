import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/bottom_nav_screen.dart';
import 'package:task_manager_project/ui/screens/login_screen.dart';
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
    bool isLoggedIn = await AuthController.chechAuthState();
    Future.delayed(const Duration(seconds: 7)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  isLoggedIn ? const BottomNavScreen() : const LoginScreen()),
          (route) => false);
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
              Lottie.asset('asset/images/splash.json',width: 150),
              Text('Task Manager',style: Theme.of(context).textTheme.titleLarge,)
            ],
          ),
        ),
      ),
    );
  }
}
