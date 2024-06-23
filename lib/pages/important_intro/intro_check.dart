import 'package:shared_preferences/shared_preferences.dart';

class IntroCheck {
  static Future<bool> isFirstTime() async {

    return true;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    // if (isFirstTime) {
    //   await prefs.setBool('isFirstTime', false);
    // }
    // return isFirstTime;
  }
}
