import 'package:fchat/config.dart';
import 'package:fchat/storage/jwt_data.dart';
import 'package:fchat/utils/notification_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket = IO.io(API, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false
  });
  final JwtData _jwtData = JwtData();
  final NotificationService _notificationService = NotificationService();
  int i = 0;
  connect() {
    if (socket.connected) {
      return;
    }
    //http://173.82.86.87:5000

    socket.onConnect((data) {
      socket.emit("signin", _jwtData.id);
      // socket.on("message", (data) {
      //   setMessage("destination", data["message"]);
      // });
      socket.on('noti', (a) {
        _notificationService.showLocalNotification(
            id: i++,
            title: "AppLifecycleState.resumed",
            body: "Time to drink some water!",
            payload: "You just took water! Huurray!");
      });
    });
    socket.connect();
  }

  static final SocketService _singleton = SocketService._internal();
  factory SocketService() {
    return _singleton;
  }
  SocketService._internal();
}
