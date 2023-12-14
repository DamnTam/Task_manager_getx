import 'package:get/get.dart';
import '../models/user_model.dart';
import '../network/network_caller.dart';
import '../network/network_response.dart';
import '../network/urls.dart';
import 'authController.dart';

class LoginController extends GetxController{
  bool _isLogin=false;
  String _snackMessage='';
  bool get isLogin  =>_isLogin;
  String get snackMessage  =>_snackMessage;


  Future<bool> login(String email,String password) async {
      _isLogin = true;
      update();
      NetworkResponse response = await NetworkCaller().postRequest(Urls.loginUrl, body: {
        'email': email,
        'password': password
      });
      _isLogin = false;
      update();
      //print(response.jsonBody);
      if (response.isSuccess) {
        await Get.find<AuthController>().saveUserInfo(response.jsonBody['token'],
            UserModel.fromJson(response.jsonBody['data']));
        _snackMessage='Login Successfull';
        return true;
        // await AuthController.initializeUser();
      }
      else{
        _snackMessage='Login Failed!!';
        return false;
      }

  }
}