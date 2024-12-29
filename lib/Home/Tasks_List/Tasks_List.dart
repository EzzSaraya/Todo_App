import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Home/Tasks_List/task_item.dart';
import 'package:todo_app/firebaseUtils.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/provider/listProvider.dart';
import 'package:todo_app/provider/userProvider.dart';

class TasksListTab extends StatefulWidget {
  @override
  State<TasksListTab> createState() => _TasksListTabState();
}

class _TasksListTabState extends State<TasksListTab> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);
    if (listProvider.tasklist.isEmpty) {
      listProvider.getTasksFromFireStore(userProvider.currentuser!.id!);
    }

    return Column(
      children: [
        EasyDateTimeLine(
          locale: 'en',
          initialDate: listProvider.selectDate,
          onDateChange: (selectedDate) {
            listProvider.changeSelectedDate(
                selectedDate, userProvider.currentuser?.id ?? '');
            //`selectedDate` the new date selected.
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.dropDown,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: const EasyDayProps(
            dayStructure: DayStructure.monthDayNumDayStr,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff3371FF),
                    Color(0xff8426D6),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: listProvider.tasklist.isEmpty
              ? Center(
                  child: Text("No Tasks Available"),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: listProvider.tasklist[index],
                    );
                  },
                  itemCount: listProvider.tasklist.length,
                ),
        )
      ],
    );
  }
}
