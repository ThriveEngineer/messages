import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(25, 25, 25, 25),
    primary: const Color.fromARGB(255, 255, 255, 255),
    secondary: const Color.fromARGB(255, 30, 30, 30),
    tertiary: const Color.fromARGB(255, 20, 20, 20),
    inversePrimary: Colors.grey.shade300,
  ),
);