import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app/firebaseUtils.dart';
import 'package:todo_app/model/task.dart';

class ListProvider extends ChangeNotifier {
  List<Task> tasklist = [];
  var selectDate = DateTime.now();

  void getTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querysnapshot =
        await FireBaseUtils.getTaskCollection(uId).get(); //collection
    tasklist = querysnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasklist = tasklist.where((task) {
      if (selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year) {
        return true;
      }
      return false;
    }).toList();

    tasklist.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();

// put the task list in documents that is in task collection to add it in the
  }

  void changeSelectedDate(DateTime newSelectDate, String uId) {
    selectDate = newSelectDate;
    getTasksFromFireStore(uId);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasklist.remove(task); // Remove the task from the list
    notifyListeners(); // Notify UI to update
  }
}
