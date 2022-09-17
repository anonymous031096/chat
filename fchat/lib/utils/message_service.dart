import 'package:fchat/utils/http_service.dart';

class MessageService {
  final HttpService _httpService = HttpService();

  Future<List<dynamic>> getMessage(String senderId, String receiverId) async {
    try {
      var response = await _httpService.get('message/$senderId/$receiverId');
      return response.data;
    } catch (e) {
      return [];
    }
  }

  static final MessageService _singleton = MessageService._internal();
  factory MessageService() {
    return _singleton;
  }
  MessageService._internal();
}
