import 'package:flutter/material.dart';

class ButtonCard extends StatelessWidget {
  const ButtonCard({super.key, required this.name, required this.icon});
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        backgroundColor: const Color(0xFF26D366),
        child: Icon(
          icon,
          size: 26,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
