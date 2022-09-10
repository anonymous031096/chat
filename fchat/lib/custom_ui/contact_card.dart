import 'package:fchat/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key, required this.contact});
  final ChatModel contact;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.blueGrey[200],
          child: SvgPicture.asset(
            "assets/person.svg",
            color: Colors.white,
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          contact.status,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
