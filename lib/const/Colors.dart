import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF5926E2);
const Color secondaryColor = Color(0xff69D8C5);
const Color accentColor = Color(0xFFA6E1F2);
const Color backgroundColor = Color(0xFFF5F2F5);

const Color textColorPrimary = Color(0xFF020002);
const Color textColorSecondary = Color(0xff000000);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: "Roboto",
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
      color: textColorPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: textColorPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: textColorPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      color: textColorSecondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: textColorSecondary,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: primaryColor)
      .copyWith(secondary: secondaryColor)
      .copyWith(tertiary: accentColor)
      .copyWith(background: backgroundColor),
);
