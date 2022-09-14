import 'package:fchat/utils/http_service.dart';
import 'package:http/http.dart';

class MessageService {
  final HttpService _httpService = HttpService();

  Future<Response> getMessage(String senderId, String receiverId) {
    return _httpService.get('message/$senderId/$receiverId');
  }

  static final MessageService _singleton = MessageService._internal();
  factory MessageService() {
    return _singleton;
  }
  MessageService._internal();
}
