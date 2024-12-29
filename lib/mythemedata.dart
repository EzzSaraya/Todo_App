import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/AppColors.dart';

class MyThemeData {
  static final ThemeData LightTheme = ThemeData(
      primaryColor: AppColors.PrimaryColor,
      scaffoldBackgroundColor: AppColors.BackgroundLightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.PrimaryColor,
        elevation: 0,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(
            color: AppColors.WhiteColor,
            fontSize: 22,
            fontWeight: FontWeight.bold),
        titleSmall: GoogleFonts.inter(
            color: AppColors.BlackColor,
            fontSize: 20,
            fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.inter(
            color: AppColors.GrayColor,
            fontSize: 18,
            fontWeight: FontWeight.w400),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          showUnselectedLabels: false,
          unselectedItemColor: AppColors.GrayColor,
          selectedItemColor: AppColors.PrimaryColor,
          elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.PrimaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
              side: BorderSide(color: AppColors.WhiteColor, width: 4))));
}
