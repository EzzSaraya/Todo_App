import 'package:flutter/material.dart';
import 'package:todo_app/AppColors.dart';

typedef MyValidator = String? Function(String?)?;

class CustomTextField extends StatelessWidget {
  String label;
  TextEditingController controller;
  MyValidator validator;
  TextInputType keyboardType;
  bool obscureText;

  CustomTextField(
      {required this.label,
      required this.controller,
      required this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.PrimaryColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.PrimaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.RedColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.RedColor, width: 2),
            ),
            labelText: label,
            errorMaxLines: 2),
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        //security of text
        keyboardType: keyboardType,
      ),
    );
  }
}
