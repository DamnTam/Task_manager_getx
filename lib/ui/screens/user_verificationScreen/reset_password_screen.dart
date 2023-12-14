import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/resetPasswordController.dart';
import 'package:task_manager_project/ui/screens/user_verificationScreen/login_screen.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../../widgets/body_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email,otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  ResetPassWordController resetPassWordController=Get.find<ResetPassWordController>();
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
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Minimum length password 8 character latter and number combination',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Password",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        hintText: "Confirm Password",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GetBuilder<ResetPassWordController>(
                      builder: (resetPassWordController) {
                        return Visibility(
                          visible: resetPassWordController.confirmInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: setPassword,
                              child: const Text('Confirm'),
                            ),
                          ),
                        );
                      }
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Have an account?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
                          },
                          child: const Text(
                            'Sign In',
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


  Future<void> setPassword() async {
    if (!_globalKey.currentState!.validate()) {
      return;
    }
    if (passwordController.text == confirmPasswordController.text) {
      final response = await resetPassWordController.setPassword(
          widget.email, widget.otp, passwordController.text);
      if (response) {
        if (mounted) {
          showSnackBar(context, resetPassWordController.snackMessage);
        }
        Get.to(const LoginScreen());
      }
      else{
        if(mounted) {
          showSnackBar(context, resetPassWordController.snackMessage, true);
        }
      }
    }
    else{
      if(mounted){
        showSnackBar(context, 'Both Password should be same',true);
      }
    }
  }


}
