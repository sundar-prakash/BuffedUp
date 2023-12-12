import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFF07138);
const Color secondaryColor = Color(0xffe16dbd);
const Color accentColor = Color(0xFFFFC453);
const Color backgroundColor = Color(0xFFFBFBFD);

const Color textColorPrimary = Color(0xFF333333); // Dark Grey
const Color textColorSecondary = Color.fromARGB(255, 37, 37, 37); // Medium Grey

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
