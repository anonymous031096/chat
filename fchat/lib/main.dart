import 'package:fchat/screens/home_screen.dart';
import 'package:fchat/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "OpenSans",
          colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: const Color(0xFF075E54),
              secondary: const Color(0xFF128C7E)),
        ),
        home: const LoginScreen());
  }
}
