import 'package:flutter/material.dart';

const darkbackGroundColor = Color(0xFF15181F);

const appTextStyleDark =
    TextStyle(color: Colors.white, fontFamily: "Roboto_Condensed");

const appTextStyleLight =
    TextStyle(color: darkbackGroundColor, fontFamily: "Roboto_Condensed");

class ThemeManager {
  ThemeData defaultThemeData = ThemeData(
    scaffoldBackgroundColor: Colors.black, //Color(0XFFF5F5F5), //const Color(0xFFF6F1EE),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
          if (states.contains(MaterialState.dragged)) return Colors.blueAccent.withOpacity(0.5);
          return Colors.black45.withOpacity(0.5);
        },
      ),
      thickness: MaterialStateProperty.all(8),
      radius: Radius.circular(8),
      thumbVisibility: MaterialStateProperty.all(false), // default behavior
    ),
    textTheme: TextTheme(
      displayLarge: appTextStyleLight,
      displayMedium: appTextStyleLight,
      displaySmall: appTextStyleLight,
      headlineLarge: appTextStyleLight,
      headlineMedium: appTextStyleLight,
      headlineSmall: appTextStyleLight,
      titleLarge: appTextStyleLight,
      titleMedium: appTextStyleLight,
      titleSmall: appTextStyleLight,
      bodyLarge: appTextStyleLight,
      bodyMedium: appTextStyleLight,
      bodySmall: appTextStyleLight,
      labelLarge: appTextStyleLight,
      labelMedium: appTextStyleLight,
      labelSmall: appTextStyleLight,
    ),
    dialogBackgroundColor: Color(0XFFF5F5F5), //Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 246, 244, 243),
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withOpacity(.60),
    ),
    listTileTheme: ListTileThemeData(
        leadingAndTrailingTextStyle: TextStyle(color: Colors.black)),
    iconTheme: IconThemeData(color: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFFED7D31)))),
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
  ThemeData darkThemeData = ThemeData(
    scaffoldBackgroundColor: darkbackGroundColor,
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
          if (states.contains(MaterialState.dragged)) return Color(0xFF424242);
          return Color(0xFF424242); // Colors.white70.withOpacity(0.5); // visible on dark backgrounds
        },
      ),
      thickness: MaterialStateProperty.all(8),
      radius: Radius.circular(8),
      thumbVisibility: MaterialStateProperty.all(true), // if you want always visible
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: appTextStyleDark,
      displayMedium: appTextStyleDark,
      displaySmall: appTextStyleDark,
      headlineLarge: appTextStyleDark,
      headlineMedium: appTextStyleDark,
      headlineSmall: appTextStyleDark,
      titleLarge: appTextStyleDark,
      titleMedium: appTextStyleDark,
      titleSmall: appTextStyleDark,
      bodyLarge: appTextStyleDark,
      bodyMedium: appTextStyleDark,
      bodySmall: appTextStyleDark,
      labelLarge: appTextStyleDark,
      labelMedium: appTextStyleDark,
      labelSmall: appTextStyleDark,
    ),
    dialogBackgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkbackGroundColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(.60),
    ),
    listTileTheme: ListTileThemeData(
        leadingAndTrailingTextStyle: TextStyle(color: Colors.white)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue))),
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
