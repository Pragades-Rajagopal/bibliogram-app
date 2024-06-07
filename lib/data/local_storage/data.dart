import 'package:bibliogram_app/configurations/token_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserToken {
  int? id;
  String? fullname;
  String? username;

  UserToken({
    this.id,
    this.fullname,
    this.username,
  });

  UserToken.parseToken(String? token) {
    final payloadData = parseJwtPayLoad(token!);
    id = payloadData["id"];
    username = payloadData["username"];
    fullname = payloadData["fullname"];
  }

  static Future<void> storeTokenData(UserToken data, String? token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('user_id', data.id.toString());
    await preferences.setString('fullname', data.fullname!);
    await preferences.setString('username', data.username!);
    await preferences.setString('token', token!);
  }

  static Future<Map<String, dynamic>> getStoreTokenData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final id = preferences.getString('user_id');
    final name = preferences.getString('fullname');
    final username = preferences.getString('username');
    final token = preferences.getString('token');
    return {
      "id": id,
      "name": name,
      "username": username,
      "token": token,
    };
  }

  static Future<void> purgeTokenData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('user_id');
    await preferences.remove('fullname');
    await preferences.remove('username');
    await preferences.remove('token');
  }
}

class SettingsData {
  String? selectedTheme;

  SettingsData({
    this.selectedTheme,
  });

  static Future<void> storeSettingsData(String selectedTheme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('selected_theme', selectedTheme);
  }

  static Future<Map<String, dynamic>> getSettingsData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final selectedTheme = preferences.getString('selected_theme');
    return {
      "selectedTheme": selectedTheme,
    };
  }

  static Future<void> purgeSettingsData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('selected_theme');
  }
}
