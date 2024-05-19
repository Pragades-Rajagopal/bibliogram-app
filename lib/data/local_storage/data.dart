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
}
