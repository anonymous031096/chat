import 'package:fchat/custom_ui/button_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:fchat/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ChatModel sourceChat;
  List<ChatModel> chats = [
    ChatModel(
        name: "Duc",
        isGroup: false,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg",
        id: 1),
    ChatModel(
        name: "Huyen",
        isGroup: true,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg",
        id: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) => InkWell(
              onTap: () {
                sourceChat = chats.removeAt(index);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => HomeScreen(
                              chatModels: chats,
                              sourceChat: sourceChat,
                            )));
              },
              child: ButtonCard(name: chats[index].name, icon: Icons.person))),
    );
  }
}
