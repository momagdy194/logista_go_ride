import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      fontFamily: "Cairo",
      primarySwatch: Colors.green,
      colorScheme: ColorScheme(
          brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          primary: isDarkTheme ? AppColors.darkModePrimary : AppColors.primary,
          onPrimary: isDarkTheme ? AppColors.primary : AppColors.darkModePrimary,
          secondary: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          onSecondary: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          error: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          onError: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          background: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          onBackground: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          surface: isDarkTheme ? AppColors.darkBackground : AppColors.background,
          onSurface: isDarkTheme ? AppColors.darkBackground : AppColors.background),
      primaryColor: isDarkTheme ? AppColors.primary : AppColors.darkModePrimary,
      hintColor: isDarkTheme ? Colors.white38 : Colors.black38,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: Color(0xffF5F5F5),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary, //  <-- dark text for light background
        colorScheme: Theme.of(context).colorScheme.copyWith(primary: isDarkTheme ? AppColors.darkModePrimary : AppColors.primary),
      ),
      appBarTheme: AppBarTheme(centerTitle: true, iconTheme: const IconThemeData(color: Colors.white), titleTextStyle: GoogleFonts.cairo(color: Colors.white, fontSize: 16)),
    );
  }
}
