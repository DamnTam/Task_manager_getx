import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../network/network_caller.dart';
import '../network/urls.dart';
import 'authController.dart';

class UpdateProfileController extends GetxController{
  bool _updateInProgress=false;
  String _snackMessage='';
  bool get  updateInProgress => _updateInProgress;
  String get snackMessage =>_snackMessage;
  Future<bool> updateProfile(String email,firstName,lastName,mobile,password,XFile? photo) async {

    Map<String, dynamic> inputData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };
    if (password.isNotEmpty) {
      inputData["password"] = password;
    }
    String? imageBase64;
    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();
      imageBase64 = base64Encode(imageBytes);
      inputData['photo'] = imageBase64;
    }
    _updateInProgress = true;
    update();
    final response = await NetworkCaller().postRequest(Urls.profileUpdateUrl, body: inputData);
    _updateInProgress = false;
    update();

    if (response.isSuccess) {
      _snackMessage='Update Successfull';
      Get.find<AuthController>().updateUserInfo(UserModel(
          email: email,
          firstName: firstName,
          lastName: lastName,
          mobile: mobile,
          photo: imageBase64 ?? Get.find<AuthController>().user?.photo ?? ''));

      return true;
    }
    else if (response.isSuccess == false) {
      _snackMessage ='Update Failed!!';
    }


    log(response.statusCode.toString());
    return false;

  }
}