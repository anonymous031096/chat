import 'dart:convert';

import 'package:fchat/custom_ui/custom_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:fchat/pages/individual_page.dart';
import 'package:fchat/screens/select_contact.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:fchat/utils/socket_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatModel> chatModels = [];
  final SocketService _socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _socketService.connect();
    _socketService.socket.on('USERS', (users) {
      var datas = users as List<dynamic>;
      for (var element in datas) {
        if (element['_id'] == JwtData().id) {
          continue;
        }
        setState(() {
          chatModels.add(ChatModel(name: element['name'], id: element['_id']));
        });
      }
    });
  }

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
        itemCount: chatModels.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualPage(
                  chatModel: chatModels[index],
                ),
              ),
            );
          },
          child: CustomCard(chatModel: chatModels[index]),
        ),
      ),
    );
  }
}
