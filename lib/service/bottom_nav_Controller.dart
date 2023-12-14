import 'package:get/get.dart';

class BottomNavController extends GetxController{
  int selectedIndex=0;
  void ChangeScreen(int index){
    selectedIndex=index;
    update();
  }
  void backToHome(){
    selectedIndex=0;
  }
}