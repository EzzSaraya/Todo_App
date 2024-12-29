import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/firebaseUtils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/listProvider.dart';
import 'package:todo_app/provider/userProvider.dart';

class AddTasksTab extends StatefulWidget {
  @override
  State<AddTasksTab> createState() => _AddTasksTabState();
}

class _AddTasksTabState extends State<AddTasksTab> {
  var selectedDate = DateTime.now();
  var formKey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      color: AppColors.WhiteColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Add New Task ",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColors.BlackColor)),
            ),
            Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (text) {
                          title = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Please Enter your Task";
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: "Enter Your Task"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (text) {
                          desc = text;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Please Enter task description";
                          }
                          return null;
                        },
                        decoration:
                            InputDecoration(hintText: "Enter Task Description"),
                        maxLines: 4,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Select Date",
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                          onPressed: () {
                            showCalender();
                          },
                          child: Text(
                            ' ${selectedDate.day}/${selectedDate.month}'
                            '/${selectedDate.year}',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          addTask();
                        },
                        child: Text(
                          "Add Task",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColors.WhiteColor,
                          backgroundColor: AppColors.PrimaryColor,
                          elevation: 6.0,
                          shadowColor: Colors.yellow[200],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void showCalender() async {
    var ChosenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (ChosenDate != null) {
      selectedDate = ChosenDate;
    }
    setState(() {});
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Task task = Task(description: desc, title: title, dateTime: selectedDate);
      var userprovider = Provider.of<UserProvider>(context, listen: false);
      FireBaseUtils.addTaskToFireStore(task, userprovider.currentuser!.id!)
          .then((value) {
        print("Task Added Successfully");
        listProvider.getTasksFromFireStore(userprovider.currentuser!.id!);
        Navigator.pop(context);
      }).timeout(Duration(seconds: 1), onTimeout: () {
        print("Task Added Successfully");
        listProvider.getTasksFromFireStore(userprovider.currentuser!.id!);
        Navigator.pop(context);
      });
    }
  }
}
