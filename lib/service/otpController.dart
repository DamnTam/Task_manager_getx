import 'package:get/get.dart';

import '../network/network_caller.dart';
import '../network/urls.dart';

class OtpController extends GetxController{
   bool _verifyInProgress=false;
   String _snackMessage='';
   bool get verifyInProgress=>_verifyInProgress;
   String get snackMessage=>_snackMessage;
  Future<bool> recoverVerifyOtp(String email,otp) async {
    if (otp.isNotEmpty) {
      _verifyInProgress = true;
      update();
      final response = await NetworkCaller()
          .getRequest(Urls.verifyOtpUrls(email, otp));
      _verifyInProgress = false;
      update();
      if (response.jsonBody['status'] == 'success') {
        _snackMessage='SuccessFull';
        return true;

      } else if (response.jsonBody['status'] == 'fail') {
        _snackMessage='Failed';
      }

    }
    else{
      _snackMessage='empty';
    }
    return false;
    }
  }
