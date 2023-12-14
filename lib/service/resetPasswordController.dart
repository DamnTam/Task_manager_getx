import 'package:get/get.dart';

import '../network/network_caller.dart';
import '../network/urls.dart';

class ResetPassWordController extends GetxController{
  bool confirmInProgress=false;
  String snackMessage='';

  Future<bool> setPassword(String email,otp,password) async{

      confirmInProgress=true;
      update();
      final response = await NetworkCaller().postRequest(Urls.setPasswordUrl,body: {
        "email":email,
        "OTP":otp,
        "password":password
      });
      confirmInProgress=false;
      update();
      if(response.jsonBody['status']=='success'){
       snackMessage='Successfull';
       return true;
      }
      else{
       snackMessage='Failed';
      }
      return false;

    }

  }
