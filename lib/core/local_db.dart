import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id2') ?? '';
  }

  static Future<void> setUserId() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id2', DateTime.now().microsecond.toString());
  }
}
