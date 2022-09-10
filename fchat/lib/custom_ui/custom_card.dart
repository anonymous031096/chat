import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(radius: 30),
      title: const Text(
        "Duc dev",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: const [
          Icon(Icons.done_all),
          SizedBox(width: 3),
          Text("Hi duc dev", style: TextStyle(fontSize: 13))
        ],
      ),
      trailing: const Text("18:00"),
    );
  }
}
