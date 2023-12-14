import 'package:flutter/material.dart';
import 'package:task_manager_project/service/deleteTaskController.dart';
import 'package:get/get.dart';
import 'package:task_manager_project/service/updateTaskController.dart';
import 'package:task_manager_project/ui/widgets/global_loading.dart';
import 'package:task_manager_project/ui/widgets/snackBar.dart';
import '../../models/task.dart';

enum TaskStatus { New, Progress, Complete, Cancelled }

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.refreshTask,
    required this.chipColor,
    this.refreshSummary,
  });

  final Task task;
  final VoidCallback refreshTask;
  final VoidCallback? refreshSummary;
  final Color chipColor;

  // final Function(bool) deleteProgress;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  DeleteTaskController deleteTaskController = Get.find<DeleteTaskController>();
  UpdateTaskController updateTaskController = Get.find<UpdateTaskController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 1.5),
        color: Colors.amber.shade100,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(0),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Date: ${widget.task.createdDate}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ],
            ),
            Text(
              widget.task.title ?? '',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.task.description ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 7,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  label: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Text(
                      widget.task.status.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  backgroundColor: widget.chipColor,
                  side: const BorderSide(
                    color: Colors.black87,
                    width: 1.5,
                  ),
                ),
                Wrap(
                  children: [
                    IconButton(
                        onPressed: deleteTask,
                        icon: const Icon(Icons.delete_forever_outlined)),
                    IconButton(
                        onPressed: () {
                          buildShowDialog(context);
                        },
                        icon: const Icon(Icons.edit)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context) {
    List<ListTile> items = TaskStatus.values
        .map((e) => ListTile(
              title: Text(e.name),
              onTap: () {
                Navigator.pop(context);
                getUpdateTaskStatus(e.name);
              },
            ))
        .toList();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Update Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: items,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          );
        });
  }

  Future<void> getUpdateTaskStatus(String status) async {
    // widget.inProgress(true);
    GlobalLoading().loading(context);
    final response =
        await updateTaskController.UpdateTask(status, widget.task.sId);
    Get.back();
    if (response) {
      widget.refreshTask();
      widget.refreshSummary!();
    }
    // widget.inProgress(false);
  }

  Future<void> deleteTask() async {
    //widget.inProgress(true);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Column(
            children: [
              Text('Confirm Delete?'),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    //completer.complete(false); // Complete with false when canceled
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Get.back();
                    GlobalLoading().loading(context);
                    final response = await deleteTaskController
                        .deleteTask(widget.task.sId.toString());
                    Get.back();
                    if (response == true) {
                      widget.refreshTask();
                      widget.refreshSummary!();

                      if (mounted) {
                        showSnackBar(context, 'Successfully delete');
                      }
                    } else {
                      if (mounted) {
                        showSnackBar(context, ' delete failed!!', true);
                      }
                    }
                  },
                  child: const Text('Ok'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
