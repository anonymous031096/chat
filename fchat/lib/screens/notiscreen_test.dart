import 'package:flutter/material.dart';

class NotisacreenTest extends StatelessWidget {
  final String payload;
  const NotisacreenTest({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JustWater"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(payload)],
        ),
      ),
    );
  }
}
