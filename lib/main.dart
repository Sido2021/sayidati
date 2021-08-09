import 'package:flutter/material.dart';
import 'package:sayidati/views/signup.dart';

import 'views/splash.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.orange,
      accentColor: Colors.orangeAccent,
      colorScheme: ColorScheme.light(
        surface: Colors.orangeAccent,
        primary: Colors.orangeAccent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.orangeAccent,
        ),
      ),
    ),
    home:Splash(),
  ));
}