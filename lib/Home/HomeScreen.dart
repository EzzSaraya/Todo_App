import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Auth/Login/login_screen.dart';
import 'package:todo_app/Home/Settings/Settings_tab.dart';
import 'package:todo_app/Home/Tasks_List/Tasks_List.dart';
import 'package:todo_app/Home/Tasks_List/add_tasks_list.dart';
import 'package:todo_app/provider/listProvider.dart';
import 'package:todo_app/provider/userProvider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home_Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedindex = 0;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                  listProvider.tasklist = [];
                },
                icon: Icon(Icons.logout))
          ],

          // toolbarHeight: MediaQuery.of(context).size.height*0.15,
          title: Text(
            selectedindex == 0
                ? "ToDo List  ${userProvider.currentuser!.Name}"
                : "Settings",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Column(children: [
          Container(
              color: AppColors.PrimaryColor,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1),
          Expanded(child: selectedindex == 0 ? TasksListTab() : SettingsTab())
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTaskBottomSheet();
          },
          child: Icon(Icons.add, size: 35, color: AppColors.WhiteColor),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: MediaQuery.of(context).size.height * 0.02,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: BottomNavigationBar(
                  onTap: (index) {
                    selectedindex = index;
                    setState(() {});
                  },

                  // currentIndex: selectedindex,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.list,
                          size: 20,
                        ),
                        label: 'Tasks List'),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.settings,
                        size: 20,
                      ),
                      label: 'Settings',
                    )
                  ]),
            )));
  }

  // List<Widget> tabs = [TasksListTab(), SettingsTab()];

  void addTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddTasksTab(),
    );
  }
}