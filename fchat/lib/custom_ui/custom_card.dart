import 'package:fchat/models/chat_model.dart';
import 'package:fchat/pages/individual_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key, required this.chatModel, required this.sourceChat});
  final ChatModel chatModel;
  final ChatModel sourceChat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IndividualPage(
                      chatModel: chatModel,
                      sourceChat: sourceChat,
                    )));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              child: SvgPicture.asset(
                chatModel.isGroup ? "assets/groups.svg" : "assets/person.svg",
                color: Colors.white,
                height: 36,
                width: 36,
              ),
            ),
            title: Text(
              chatModel.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.done_all),
                const SizedBox(width: 3),
                Text(chatModel.currentMessage,
                    style: const TextStyle(fontSize: 13))
              ],
            ),
            trailing: Text(chatModel.time),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(thickness: 1),
          )
        ],
      ),
    );
  }
}
