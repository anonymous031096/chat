import 'package:fchat/custom_ui/button_card.dart';
import 'package:fchat/custom_ui/contact_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  List<ChatModel> contacts = [
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
    ChatModel(name: "Dev stack", status: "A full stack developer"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Select contact",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "256 contacts",
              style: TextStyle(fontSize: 13),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 26,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "Invite a friend",
                  child: Text("Invite a friend"),
                ),
                const PopupMenuItem(
                  value: "Contacts",
                  child: Text("Contacts"),
                ),
                const PopupMenuItem(
                  value: "Refresh",
                  child: Text("Refresh"),
                ),
                const PopupMenuItem(
                  value: "Help",
                  child: Text("Help"),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: contacts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const ButtonCard(name: "New group", icon: Icons.group);
          } else if (index == 1) {
            return const ButtonCard(
                name: "New contact", icon: Icons.person_add);
          }
          return ContactCard(
            contact: contacts[index - 2],
          );
        },
      ),
    );
  }
}
