import 'package:flutter/material.dart';
import 'package:task_manager_project/service/emailVerificationController.dart';
import 'package:task_manager_project/ui/screens/user_verificationScreen/pin_Verification_screen.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import 'package:get/get.dart';
import '../../widgets/body_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  EmailVerificationController emailVerificationController=Get.find<EmailVerificationController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    'Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'A 6 digit verification pin will send to your email address',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GetBuilder<EmailVerificationController>(
                    builder: (emailController) {
                      return Visibility(
                        visible: emailController.emailInProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: emailVerification,
                            child: const Icon(
                                Icons.arrow_circle_right_outlined),
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
                          Navigator.pop(context);
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
    );
  }

  Future<void> emailVerification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response=await emailVerificationController.emailVerification(emailController.text);
    if(response){
      if(mounted){
        showSnackBar(context, emailVerificationController.snackMessage);
      }
      Get.to(PinVerificationScreen(email: emailController.text));

    }
    else{
      if(mounted){
        showSnackBar(context, emailVerificationController.snackMessage,true);
      }
    }


    }
  }

