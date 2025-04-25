import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue,
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
    bodyLarge: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
    bodyMedium: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
    bodySmall: TextStyle(fontSize: 12, color: Colors.grey),
  ),
);
