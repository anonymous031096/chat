// import 'package:shared_preferences/shared_preferences.dart';

// class PrefsService {
//   SharedPreferences _prefs = SharedPreferences.getInstance();
//   final String _token = 'TOKEN';

//   init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   String get jwt {
//     return _prefs.getString(_token) ?? '';
//   }

//   set jwt(String value) {
//     _prefs.setString(_token, value);
//   }

//   static final PrefsService _singleton = PrefsService._internal();
//   factory PrefsService() {
//     return _singleton;
//   }
//   PrefsService._internal();
// }
