import 'package:flutter/material.dart';
import 'package:task_manager_project/network/network_caller.dart';
import 'package:task_manager_project/network/urls.dart';
import 'package:task_manager_project/ui/screens/login_screen.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../widgets/body_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email,otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  bool confirmInProgress=false;
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
                  Visibility(
                    visible: confirmInProgress==false,
                    replacement: const Center(child: CircularProgressIndicator(),),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: setPassword,
                        child: const Text('Confirm'),
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
    );
  }
  Future<void> setPassword() async{
    if(passwordController.text==confirmPasswordController.text){

      confirmInProgress=true;
      if(mounted){
        setState(() {

        });
      }

      final response = await NetworkCaller().postRequest(Urls.setPasswordUrl,body: {
        "email":widget.email,
        "OTP":widget.otp,
        "password":passwordController.text
      });
      if(response.jsonBody['status']=='success'){
        passwordController.clear();
        confirmPasswordController.clear();
        if(mounted){
          showSnackBar(context, 'Password Updated!!');
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen( )), (route) => false);
          
        }
        
      }
      else{
        if(mounted){
          showSnackBar(context, 'Inavalid',true);
        }
      }
      confirmInProgress=false;
      if(mounted){
        setState(() {

        });
      }
    }
    else{
      if(mounted){
        showSnackBar(context, 'new password and confirm password should be same',true);
      }
    }
  }
}
