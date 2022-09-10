import 'package:fchat/custom_ui/custom_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> chats = [
    ChatModel(
        name: "Dev stack",
        isGroup: false,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg"),
    ChatModel(
        name: "Dev stack",
        isGroup: true,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg"),
    ChatModel(
        name: "Dev stack",
        isGroup: false,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg"),
    ChatModel(
        name: "Dev stack",
        isGroup: true,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg"),
    ChatModel(
        name: "Dev stack",
        isGroup: false,
        currentMessage: "Hi everyone",
        time: "04:00",
        icon: "person.svg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) => CustomCard(chatModel: chats[index]),
      ),
    );
  }
}
