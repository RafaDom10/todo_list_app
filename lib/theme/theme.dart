import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      appBarTheme: const AppBarTheme(color: Colors.grey),
      scaffoldBackgroundColor: Colors.grey[800],
      iconTheme: const IconThemeData(color: Colors.white),
      hintColor: Colors.orange,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.white70),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w200),
      ));
}

ThemeData lightTheme() {
  return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.purple,
      appBarTheme: AppBarTheme(color: Colors.lightBlue[700]),
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      hintColor: Colors.orange,
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: Colors.orange),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w200),
      ));
}
