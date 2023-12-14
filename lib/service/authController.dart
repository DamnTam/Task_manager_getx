import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_project/models/user_model.dart';

class  AuthController extends GetxController{
  static String? token;
   UserModel? user;

  /// save user data in shared preference
   Future<void> saveUserInfo(String tokenn, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', tokenn);
    await sharedPreferences.setString('userData', jsonEncode(model));
    token=tokenn;
    user=model;
    update();
  }
  /// update user data in shared preference
   Future<void> updateUserInfo(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userData', jsonEncode(model));
    user = model;
    update();
    // Update the ValueNotifier with the new user information
    //userNotifier.value = model;
  }

  /// initialize auth data
   Future<void> initializeUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    user = UserModel.fromJson(jsonDecode(sharedPreferences.getString('userData') ?? '{}'));
    update();
  }

   Future<bool> checkAuthState() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    update();
    if (token != null) {
      initializeUser();
      return true;
    }
    return false;
  }

  ///clear userdata
  static Future<void> clearAuthCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
