import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_manager_project/network/network_caller.dart';
import 'package:task_manager_project/network/network_response.dart';
import 'package:task_manager_project/network/urls.dart';

import '../../models/task.dart';

enum TaskStatus { New, Progress, Complete, Cancelled }

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.refreshTask,
    required this.inProgress,
    required this.chipColor,
    this.refreshSummary,
  });

  final Task task;
  final VoidCallback refreshTask;
  final VoidCallback? refreshSummary;
  final Function(bool) inProgress;
  final Color chipColor;

  // final Function(bool) deleteProgress;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  Future<void> getUpdateTaskStatus(String status) async {
    widget.inProgress(true);
    NetworkResponse response = await NetworkCaller().getRequest(
        Urls.updateTaskStatusUrls(widget.task.sId.toString(), status));
    log(response.statusCode.toString());
    if (response.isSuccess) {
      widget.refreshTask();
      widget.refreshSummary!();
    }
    widget.inProgress(false);
  }

  Future<void> deleteTask() async {
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
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        widget.inProgress(true);
                        NetworkResponse response = await NetworkCaller()
                            .getRequest(Urls.deleteTaskUrls(
                                widget.task.sId.toString()));
                        log(response.statusCode.toString());
                        if (response.isSuccess) {
                          widget.refreshTask();
                          widget.refreshSummary!();
                        }
                        widget.inProgress(false);
                      },
                      child: const Text('Ok'))
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black87, width: 1.5),
        borderRadius: BorderRadius.circular(20),
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
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
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
                getUpdateTaskStatus(e.name);
                Navigator.pop(context);
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
}
