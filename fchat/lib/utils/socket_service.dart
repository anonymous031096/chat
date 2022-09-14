import 'package:fchat/storage/jwt_data.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket = IO.io("http://localhost:3000", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false
  });
  JwtData _jwtData = JwtData();

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
    });
    socket.connect();
  }

  static final SocketService _singleton = SocketService._internal();
  factory SocketService() {
    return _singleton;
  }
  SocketService._internal();
}
