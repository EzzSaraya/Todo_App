import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Auth/customTextField.dart';
import 'package:todo_app/Auth/register/registerscreen.dart';
import 'package:todo_app/Home/HomeScreen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebaseUtils.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/provider/userProvider.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login_screen';

  TextEditingController EmailController =
      TextEditingController(text: "example@gmail.com");

  TextEditingController PasswordController = TextEditingController(text: '');

  var formKey = GlobalKey<FormState>();

  // variable to check validation in all inputs
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: AppColors.BackgroundLightColor,
            child: Image.asset(
              "assets/images/background.png",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            )),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title:
                Text("Sign In", style: Theme.of(context).textTheme.titleLarge),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Text(
                        "Welcome Back!",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.BlackColor),
                      ),
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      label: "National ID",
                      controller: EmailController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Email";
                        }
                        final bool emailValid = RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(text);

                        if (!emailValid) {
                          return 'PLease Enter your Email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      label: "Password",
                      controller: PasswordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please Enter Password';
                        }
                        if (text.length < 6) {
                          return "Invalid Password "
                              "should be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('Sign In'),
                          onPressed: () {
                            login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.WhiteColor,
                            backgroundColor: AppColors.PrimaryColor,
                            elevation: 6.0,
                            shadowColor: Colors.yellow[200],
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('Or Create Account'),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RegisterScreen.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.WhiteColor,
                            backgroundColor: AppColors.PrimaryColor,
                            elevation: 6.0,
                            shadowColor: Colors.yellow[200],
                          ),
                        ))
                  ],
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }

  void login(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Waiting...');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: EmailController.text, password: PasswordController.text);
        var user = await FireBaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.UpdateUser(user);

        // todo : hide loading
        DialogUtils.hideLoading(context);
        // todo : Show Message

        DialogUtils.showMessage(
          context: context,
          content: 'Login Successfully',
          title: 'Success',
          posActionName: "OK ",
          posAction: () {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
        );
        print("Login Successfully");
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          // todo : hide loading
          DialogUtils.hideLoading(context);
          // todo : Show Message
          DialogUtils.showMessage(
            context: context,
            content: 'Auth credential is incorrect',
            title: 'Error',
            posActionName: "OK",
          );

          print('The account you are signing in with cannot be found.');

          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          // todo : hide loading
          DialogUtils.hideLoading(context);
          // todo : Show Message
          DialogUtils.showMessage(
              content: "Wrong Password! Please Try again",
              context: context,
              title: "Error",
              posActionName: "Ok");
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        // todo : hide loading
        DialogUtils.hideLoading(context);
        // todo : Show Message
        DialogUtils.showMessage(
            context: context,
            content: e.toString(),
            title: "Error",
            posActionName: 'Ok');
        print(e);
      }
    }
  }
}
