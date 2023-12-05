import 'package:flutter/material.dart';
import 'package:task_manager_project/network/network_caller.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/ui/screens/login_screen.dart';
import 'package:task_manager_project/ui/screens/reset_password_screen.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../widgets/body_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key,required this.email});
  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  TextEditingController otpController=TextEditingController();
  bool verifyInProgress=false;
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
                    'Pin Verification',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'A 6 digit verification pin will send to your email address',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey
                    ),),
                  const SizedBox(
                    height: 24,
                  ),
                  Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      controller: otpController,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        activeColor: Colors.green,
                        selectedFillColor: Colors.white,
                        selectedColor: Colors.black87,
                        inactiveFillColor: Colors.white,

                      ),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onCompleted: (v) {},
                      onChanged: (value) {

                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                      appContext: context,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: verifyInProgress==false,
                    replacement:const  Center(child: CircularProgressIndicator(),),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: recoverVerifyOtp,
                        child: const Text('Verify'),
                      ),
                    ),
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
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()), (
                                  route) => false);
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

  Future<void> recoverVerifyOtp() async {
    if (otpController.text.isNotEmpty) {
      verifyInProgress = true;
      if (mounted) {
        setState(() {});
      }
      final response = await NetworkCaller()
          .getRequest(Urls.verifyOtpUrls(widget.email, otpController.text));
      if (response.jsonBody['status'] == 'success') {
        if (mounted) {
          showSnackBar(context, 'Success');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPasswordScreen(
                        email: widget.email,
                        otp: otpController.text,
                      )));
        }
      } else if (response.jsonBody['status'] == 'fail') {
        if (mounted) {
          showSnackBar(context, 'Invalid OTP!!!!', true);
        }
      }
      verifyInProgress = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      if (mounted) {
        showSnackBar(context, 'Enter valid otp', true);
      }
    }
  }
}
