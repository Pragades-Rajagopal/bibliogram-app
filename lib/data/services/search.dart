import 'dart:convert';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/configurations/env.dart';
import 'package:bibliogram_app/data/models/search.dart';
import 'package:http/http.dart' as http;

class SearchApi {
  Future<SearchResult> globalSearch(
    String value,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["search"]}?value=$value'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    SearchResult result = SearchResult.fromJson(body["data"]);
    return result;
  }
}
