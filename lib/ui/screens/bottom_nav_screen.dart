import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/add_new_task_Screen.dart';
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
  int isSelectedIndex=0;
  final List<Widget> _screens= const [
    NewTaskScreen(),
    InProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNewTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
        body: _screens[isSelectedIndex],
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: isSelectedIndex,
        onTap: (index){
          isSelectedIndex=index;
          setState(() {
          });
        },
        selectedItemColor: Colors.deepPurple.shade300,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        items:const  [
          BottomNavigationBarItem(icon: Icon(Icons.abc),label: 'New Task'),
          BottomNavigationBarItem(icon: Icon(Icons.change_circle_outlined),label: 'In progress'),
          BottomNavigationBarItem(icon: Icon(Icons.done),label: 'Completed'),
          BottomNavigationBarItem(icon: Icon(Icons.close),label: 'Cancelled'),
        ],
      ),
    );
  }
}
