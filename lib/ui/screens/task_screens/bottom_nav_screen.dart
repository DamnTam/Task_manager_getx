import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/bottom_nav_Controller.dart';
import 'package:task_manager_project/ui/screens/task_screens/add_new_task_Screen.dart';
import 'cancelled_task_Screen.dart';
import 'completed_task_Screen.dart';
import 'inprogress_task_Screen.dart';
import 'new_task_Screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int isSelectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    InProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];
  BottomNavController bottomNavController = Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavController>(builder: (controller) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewTaskScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body: _screens[controller.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          onTap: (index) {
            controller.ChangeScreen(index);
          },
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'New Task'),
            BottomNavigationBarItem(
                icon: Icon(Icons.change_circle_outlined), label: 'In progress'),
            BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
            BottomNavigationBarItem(
                icon: Icon(Icons.close), label: 'Cancelled'),
          ],
        ),
      );
    });
  }
}
