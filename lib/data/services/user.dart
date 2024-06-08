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

  Future<LogoutResponse> logout(
    Map<String, String> request,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["logout"]}'),
      headers: apiHeader,
      body: json.encode(request),
    );
    var body = jsonDecode(response.body);
    LogoutResponse result = LogoutResponse.fromJSON(body);
    return result;
  }

  Future<DeactivateUserResponse> deactivate(
    Map<String, String> request,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = request["userId"]!;
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["deactivateUser"]}'),
      headers: apiHeader,
      body: json.encode(request),
    );
    var body = jsonDecode(response.body);
    DeactivateUserResponse result = DeactivateUserResponse.fromJSON(body);
    return result;
  }
}
