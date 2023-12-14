 import 'package:flutter/material.dart';

 import 'package:get/get.dart';

 class GlobalLoading {
   loading(context) {
     Get.dialog(
       const Dialog(
         backgroundColor: Colors.transparent,
         child: Center(
           child: CircularProgressIndicator(
             color: Colors.black87,
             backgroundColor: Colors.transparent,
           ),
         ),
       ),
     );

     // Close the dialog after 2 seconds
   /*  Future.delayed(const Duration(seconds: 2), () {
       Get.back();
     });

    */
   }
 }
