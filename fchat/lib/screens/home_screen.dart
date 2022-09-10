import 'package:fchat/pages/chat_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatsapp"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton<String>(onSelected: (value) {
            print(value);
          }, itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(value: "New group", child: Text("New group")),
              const PopupMenuItem(
                  value: "New broadcast", child: Text("New broadcast")),
              const PopupMenuItem(
                  value: "Whatsapp web", child: Text("Whatsapp web")),
              const PopupMenuItem(
                  value: "Starred messages", child: Text("Starred messages")),
              const PopupMenuItem(value: "Settings", child: Text("Settings")),
            ];
          })
        ],
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                text: "CHATS",
              ),
              Tab(
                text: "STATUS",
              ),
              Tab(
                text: "CALLS",
              ),
            ]),
      ),
      body: TabBarView(controller: _tabController, children: const [
        Text("camera"),
        ChatPage(),
        Text("status"),
        Text("calls"),
      ]),
    );
  }
}
