import 'package:shared_preferences/shared_preferences.dart';

class CheckPremium {
  static Future<bool> getSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('ISBUY') ?? false;
  }

  static Future<void> setSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('ISBUY', true);
  }
}
