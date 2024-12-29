import 'package:flutter/material.dart';
import 'package:todo_app/model/User.dart';

class UserProvider extends ChangeNotifier {
  MyUser? currentuser;

  void UpdateUser(MyUser newUser) {
    currentuser = newUser;
    notifyListeners();
  }
}
