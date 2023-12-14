import 'package:get/get.dart';

import '../network/network_caller.dart';
import '../network/urls.dart';

class EmailVerificationController extends GetxController{
  bool _emailInProgress=false;
  String _snackMessage='';
  bool get emailInProgress=>_emailInProgress;
  String get snackMessage=>_snackMessage;
  Future<bool> emailVerification(String email) async {
    _emailInProgress = true;
    update();
    final response = await NetworkCaller().getRequest(Urls.emailVerificationUrls(email));
    _emailInProgress = false;
    update();
    if (response.jsonBody['status'] == 'success') {
     _snackMessage='SuccessFull';
     return true;
    } else {
      _snackMessage='Failed!!!';
    }
    return false;

  }
}
