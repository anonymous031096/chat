import 'package:fchat/models/chat_model.dart';
import 'package:fchat/screens/home_screen.dart';
import 'package:fchat/screens/login_screen.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('TOKEN');
    String? token = prefs.getString('TOKEN');
    await Future.delayed(const Duration(seconds: 2));
    nextPage(token);
  }

  nextPage(token) {
    JwtData jwtData = JwtData();
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) {
            if (token != null) {
              jwtData.setData(token);
              return HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
          transitionsBuilder: (c, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 1000),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            Color(0xFFFC5C7D),
            Color(0xFF6A82FB),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 90.0),
      child: const Icon(
        Icons.face,
        size: 100,
      ),
    );
  }
}
