import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/firebaseUtils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/listProvider.dart';
import 'package:todo_app/provider/userProvider.dart';

class TaskItem extends StatelessWidget {
  Task task;

  TaskItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio: 0.25,
          // A motion is a widget used to control how the pane animates.
          motion: const DrawerMotion(),
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              onPressed: (context) {
                FireBaseUtils.deletetaskfromFireStore(
                        task, userProvider.currentuser!.id!)
                    .then((value) {
                  print('Task deleted successfully');
                  listProvider
                      .getTasksFromFireStore(userProvider.currentuser!.id!);
                }).timeout(Duration(seconds: 1), onTimeout: () {
                  print('Task deleted successfully');
                  listProvider
                      .getTasksFromFireStore(userProvider.currentuser!.id!);
                });
              },
              backgroundColor: AppColors.RedColor,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.WhiteColor,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                color: AppColors.PrimaryColor,
                height: MediaQuery.of(context).size.height * 0.1,
                width: 3,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: AppColors.PrimaryColor),
                    ),
                    Text(
                      task.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      task.isDone ? Colors.green : AppColors.PrimaryColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  print('Check button pressed for task: ${task.title}');
                  task.isDone = true; // Mark task as done locally

                  // Update Firestore and refresh tasks
                  FireBaseUtils.updateTaskInFireStore(
                          task, userProvider.currentuser!.id!)
                      .then((value) {
                    print('Task marked as done');
                    listProvider.getTasksFromFireStore(
                        userProvider.currentuser!.id!); // Refresh tasks
                    listProvider.removeTask(task);
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Task "${task.title}" marked as done')),
                    );
                  }).catchError((error) {
                    print('Error marking task as done: $error');

                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to mark task as done')),
                    );
                  });
                },
                child: Icon(
                  Icons.check,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
