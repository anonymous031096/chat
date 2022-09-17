import 'package:fchat/pages/chat_page.dart';
import 'package:fchat/screens/login_screen.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:fchat/utils/notification_service.dart';
import 'package:fchat/utils/socket_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  final JwtData _jwtData = JwtData();
  final SocketService _socketService = SocketService();
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _socketService.connect();

    _jwtData.reLogin$.listen((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    });
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int i = 0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // switch (state) {
    //   case AppLifecycleState.resumed:
    //     _notificationService.showLocalNotification(
    //         id: i++,
    //         title: "AppLifecycleState.resumed",
    //         body: "Time to drink some water!",
    //         payload: "You just took water! Huurray!");
    //     break;
    //   case AppLifecycleState.inactive:
    //     _notificationService.showLocalNotification(
    //         id: i++,
    //         title: "AppLifecycleState.inactive",
    //         body: "Time to drink some water!",
    //         payload: "You just took water! Huurray!");
    //     break;
    //   case AppLifecycleState.paused:
    //     _notificationService.showLocalNotification(
    //         id: i++,
    //         title: "AppLifecycleState.paused",
    //         body: "Time to drink some water!",
    //         payload: "You just took water! Huurray!");
    //     break;
    //   case AppLifecycleState.detached:
    //     print('app closed');
    //     _notificationService.showLocalNotification(
    //         id: i++,
    //         title: "AppLifecycleState.detached",
    //         body: "Time to drink some water!",
    //         payload: "You just took water! Huurray!");
    //     break;
    //   default:
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Whatsapp"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton<String>(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                    value: "New group", child: Text("New group")),
                const PopupMenuItem(
                    value: "New broadcast", child: Text("New broadcast")),
                const PopupMenuItem(
                    value: "Whatsapp web", child: Text("Whatsapp web")),
                const PopupMenuItem(
                    value: "Starred messages", child: Text("Starred messages")),
                const PopupMenuItem(value: "Settings", child: Text("Settings")),
              ];
            },
            icon: const Icon(Icons.more_vert),
          )
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
      body: TabBarView(controller: _tabController, children: [
        Text("camera"),
        ChatPage(),
        Text("status"),
        Text("calls"),
      ]),
    );
  }
}
