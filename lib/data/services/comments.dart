import 'dart:convert';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/configurations/env.dart';
import 'package:bibliogram_app/data/models/comment.dart';
import 'package:http/http.dart' as http;

class CommentsApi {
  Future<Comments> getCommentsByQuery(
    Map<String, dynamic> query,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse(
          '${env["URL"]}${endpoints["comments"]}?noteId=${query["noteId"]}&limit=${query["limit"]}&offset=${query["offset"]}'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    Comments result = Comments.fromJson(body["data"]);
    return result;
  }

  Future<Comment> getCommentById(
    int commentId,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["book-notes"]}/$commentId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    Comment result = Comment.fromJson(body["data"][0]);
    return result;
  }

  Future<AddCommentResponse> addComment(
      Map<String, dynamic> request, String userId, String token) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.put(
      Uri.parse('${env["URL"]}${endpoints["comments"]}'),
      body: json.encode(request),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    AddCommentResponse result = AddCommentResponse.fromJson(body);
    return result;
  }
}
