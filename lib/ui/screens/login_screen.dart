import 'package:flutter/material.dart';
import 'package:task_manager_project/models/user_model.dart';
import 'package:task_manager_project/network/network_caller.dart';
import 'package:task_manager_project/network/network_response.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/ui/screens/bottom_nav_screen.dart';
import 'package:task_manager_project/ui/screens/forgot_password_screen.dart';
import 'package:task_manager_project/ui/screens/signup_screen.dart';
import 'package:task_manager_project/ui/widgets/body_background.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';

import '../../service/authController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Get Started With',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter an email!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter an password!!!';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: isLogin == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordScreen()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_globalKey.currentState!.validate()) {
      isLogin = true;
      if (mounted) {
        setState(() {});
      }
      NetworkResponse response = await NetworkCaller()
          .postRequest(Urls.loginUrl, body: {
        'email': _emailController.text,
        'password': _passwordController.text
      });
      isLogin = false;
      if (mounted) {
        setState(() {});
      }
      //print(response.jsonBody);
      if (response.isSuccess) {
        await AuthController.saveUserInfo(response.jsonBody['token'],
            UserModel.fromJson(response.jsonBody['data']));
        // await AuthController.initializeUser();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavScreen()),
              (route) => false);
        }
      } else {
        if (mounted) {
          showSnackBar(context, 'Incorrect Password!!!', true);
        }
      }
    }
  }
}
