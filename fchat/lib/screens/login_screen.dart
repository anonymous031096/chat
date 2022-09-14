import 'dart:convert';
import 'dart:io';

import 'package:fchat/screens/home_screen.dart';
import 'package:fchat/screens/notiscreen_test.dart';
import 'package:fchat/storage/auth_data.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:fchat/utils/auth_service.dart';
import 'package:fchat/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  JwtData _jwtData = JwtData();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final NotificationService notificationService;

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NotisacreenTest(payload: payload)));
      });

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.phone_android, size: 100),
              const SizedBox(height: 75),
              Text("Hello Again!", style: GoogleFonts.bebasNeue(fontSize: 52)),
              const SizedBox(height: 10),
              const Text(
                "Welcome back, you've been missed!",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: "Username",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '    Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '    Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(25),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          Response response = await _authService.signin(
                            _emailController.text,
                            _passwordController.text,
                          );
                          dynamic responseBody = json.decode(response.body);
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString('TOKEN', responseBody['accessToken']);
                          _jwtData.setData(responseBody['accessToken']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => HomeScreen()));
                        },
                        child: const Text('Sign in'),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(25),
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () async {
                          await notificationService.showLocalNotification(
                              id: 0,
                              title: "Drink Water",
                              body: "Time to drink some water!",
                              payload: "You just took water! Huurray!");
                        },
                        child: const Text('Test noti'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Not a member? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
