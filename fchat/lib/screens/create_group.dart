import 'package:fchat/custom_ui/avatar_card.dart';
import 'package:fchat/custom_ui/button_card.dart';
import 'package:fchat/custom_ui/contact_card.dart';
import 'package:fchat/models/chat_model.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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

  List<ChatModel> groups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "New group",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Add participants",
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
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(height: groups.isEmpty ? 10 : 90);
              }
              return InkWell(
                onTap: () {
                  if (contacts[index].select) {
                    setState(() {
                      contacts[index].select = false;
                      groups.remove(contacts[index]);
                    });
                  } else {
                    setState(() {
                      contacts[index].select = true;
                      groups.add(contacts[index]);
                    });
                  }
                },
                child: ContactCard(
                  contact: contacts[index],
                ),
              );
            },
          ),
          Visibility(
            visible: groups.isNotEmpty,
            child: Column(
              children: [
                Container(
                  height: 75,
                  color: Colors.white,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        if (contacts[index].select) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                groups.remove(contacts[index]);
                                contacts[index].select = false;
                              });
                            },
                            child: AvatarCard(
                              contact: contacts[index],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ),
                const Divider(
                  thickness: 1,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
