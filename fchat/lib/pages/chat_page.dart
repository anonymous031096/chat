import 'package:fchat/custom_ui/custom_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:fchat/screens/select_contact.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.chatModels, required this.sourceChat});
  final List<ChatModel> chatModels;
  final ChatModel sourceChat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => const SelectContact()));
        },
        child: const Icon(Icons.chat),
      ),
      body: ListView.builder(
        itemCount: widget.chatModels.length,
        itemBuilder: (context, index) => CustomCard(
          chatModel: widget.chatModels[index],
          sourceChat: widget.sourceChat,
        ),
      ),
    );
  }
}
