import 'dart:convert';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/configurations/env.dart';
import 'package:bibliogram_app/data/models/book.dart';
import 'package:http/http.dart' as http;

class BooksApi {
  Future<Book> getAllBooks(String userId, String token) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["books"]}'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    Book result = Book.fromJson(body["data"]);
    return result;
  }
}
