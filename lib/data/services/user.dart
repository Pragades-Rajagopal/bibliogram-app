import 'dart:convert';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/configurations/env.dart';
import 'package:bibliogram_app/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserApi {
  Future<LoginResponse> login(Map<String, String> request) async {
    final env = await accessENV(assetFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["login"]}'),
      headers: apiHeader,
      body: json.encode(request),
    );
    var body = jsonDecode(response.body);
    LoginResponse result = LoginResponse.fromJSON(body);
    return result;
  }

  Future<RegistrationResponse> register(Map<String, String> request) async {
    final env = await accessENV(assetFileName: '.env');
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["register"]}'),
      headers: apiHeader,
      body: json.encode(request),
    );
    var body = jsonDecode(response.body);
    RegistrationResponse result = RegistrationResponse.fromJSON(body);
    return result;
  }
}
