import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/AppColors.dart';
import 'package:todo_app/Auth/Login/login_screen.dart';
import 'package:todo_app/Auth/customTextField.dart';
import 'package:todo_app/Home/HomeScreen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebaseUtils.dart';
import 'package:todo_app/model/User.dart';
import 'package:todo_app/provider/userProvider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register_screen';

  TextEditingController UserNameController = TextEditingController(text: '');

  TextEditingController EmailController =
      TextEditingController(text: "example@gmail.com");

  TextEditingController PasswordController = TextEditingController(text: '');

  TextEditingController ConfirmPasswordController =
      TextEditingController(text: '');

  var formKey = GlobalKey<FormState>();

  // variable to check validation in all inputs
  @override
  Widget build(BuildContext context) {
    // provider = provider.of<UserProvider>(context);
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
            title: Text("Create An Account",
                style: Theme.of(context).textTheme.titleLarge),
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
                    CustomTextField(
                      keyboardType: TextInputType.name,
                      label: "User Name",
                      controller: UserNameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter UserName";
                        }

                        return null;
                      },
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.emailAddress,
                      label: "Email",
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
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      label: "Confirm Password  ",
                      controller: ConfirmPasswordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Confirm Password";
                        }
                        if (text != PasswordController.text) {
                          return "Password doesn't match Please Try Again";
                        }
                        return null;
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          child: Text('Sign Up'),
                          onPressed: () {
                            register(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.WhiteColor,
                            backgroundColor: AppColors.PrimaryColor,
                            elevation: 6.0,
                            shadowColor: Colors.yellow[200],
                          ),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                        },
                        child: Text("Have An Account?"
                            "Sign In"))
                  ],
                ),
              ),
            ]),
          ),
        )
      ],
    );
  }

  void register(BuildContext context) async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context: context, message: 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: EmailController.text,
          password: PasswordController.text,
        );
        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            Name: UserNameController.text,
            email: EmailController.text);
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.UpdateUser(myUser);
        await FireBaseUtils.addUsertoFireStore(myUser);
        // todo : hide loading
        DialogUtils.hideLoading(context);
        // todo : Show Message
        DialogUtils.showMessage(
            context: context,
            content: 'Register Successfully',
            title: 'Success',
            posActionName: "OK ",
            posAction: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });

        print("Register Successfully");
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // todo : hide loading
          DialogUtils.hideLoading(context);
          // todo : Show Message
          DialogUtils.showMessage(
              context: context,
              content: 'Password is too weak',
              title: "Error",
              posActionName: "Ok");
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          // todo : hide loading
          DialogUtils.hideLoading(context);
          // todo : Show Message
          DialogUtils.showMessage(
              context: context,
              content: 'The account already exists for that email.',
              title: "Error ",
              posActionName: "Ok");
          print('The account already exists for that email.');
        } else if (e.code == 'network-request-failed') {
          // todo : hide loading
          DialogUtils.hideLoading(context);
          // todo : Show Message
          DialogUtils.showMessage(
              context: context,
              content: 'network-request-failed.',
              title: "Error ",
              posActionName: "Ok");
          print('network-request-failed.');
        }
      } catch (e) {
        // todo : hide loading
        DialogUtils.hideLoading(context);
        // todo : Show Message
        DialogUtils.showMessage(
            context: context,
            content: e.toString(),
            title: 'Error',
            posActionName: "OK");

        print(e);
      }
    }
  }
}
