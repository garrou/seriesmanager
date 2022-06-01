import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static const tokenKey = 'jwt';

  static void setToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(tokenKey, token);
  }

  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(tokenKey) ?? '';
  }

  static void removeToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(tokenKey);
  }
}
