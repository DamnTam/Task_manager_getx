import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_project/models/user_model.dart';
import 'package:flutter/material.dart';

class  AuthController {
  static String? token;
 // static UserModel? user;
  static ValueNotifier<UserModel?> user = ValueNotifier<UserModel?>(UserModel());

  /// save user data in shared prefernce
  static Future<void> saveUserInfo(String tokenn, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', tokenn);
    await sharedPreferences.setString('userData', jsonEncode(model));
    token=tokenn;
    user.value=model;
  }

  static Future<void> updateUserInfo(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('userData', jsonEncode(model));
    user.value = model;
    // Update the ValueNotifier with the new user information
    //userNotifier.value = model;
  }

  /// initialize auth data
  static Future<void> initializeUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    user.value = UserModel.fromJson(jsonDecode(sharedPreferences.getString('userData') ?? '{}'));
  }

  static Future<bool> chechAuthState() async {
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');

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
