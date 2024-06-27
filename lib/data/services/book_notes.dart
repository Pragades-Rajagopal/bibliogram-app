import 'dart:convert';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/configurations/env.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:http/http.dart' as http;

class BookNotesApi {
  Future<BookNotes> getGlobalNotes(
      String userId, String token, int limit, int offset) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse(
          '${env["URL"]}${endpoints["book-notes"]}?limit=$limit&offset=$offset'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    BookNotes result = BookNotes.fromJson(body["data"]);
    return result;
  }

  Future<BookNote> getNoteById(int noteId, String userId, String token) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["book-notes"]}/$noteId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    BookNote result = BookNote.fromJson(body["data"][0]);
    return result;
  }

  Future<BookNotes> getNoteByQuery(
    dynamic query,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse(
          '${env["URL"]}${endpoints["book-notes"]}?userId=${query["userId"]}&bookId=${query["bookId"]}&limit=${query["limit"]}0&offset=${query["offset"]}'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    BookNotes result = BookNotes.fromJson(body["data"]);
    return result;
  }

  Future<AddorUpdateResponse> addOrUpdateNote(
    Map<String, String> request,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.put(
      Uri.parse('${env["URL"]}${endpoints["book-notes"]}'),
      headers: apiHeader,
      body: json.encode(request),
    );
    var body = jsonDecode(response.body);
    AddorUpdateResponse result = AddorUpdateResponse.fromJson(body);
    return result;
  }

  Future<DeleteNoteResponse> deleteNote(
    int noteId,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.delete(
      Uri.parse('${env["URL"]}${endpoints["book-notes"]}/$noteId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    DeleteNoteResponse result = DeleteNoteResponse.fromJson(body);
    return result;
  }

  //Save note for later
  Future<SaveNoteForLaterResponse> saveNoteForLater(
    Map<String, dynamic> request,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.post(
      Uri.parse('${env["URL"]}${endpoints["save-note"]}'),
      headers: apiHeader,
      body: json.encode(request),
    );
    var body = jsonDecode(response.body);
    SaveNoteForLaterResponse result = SaveNoteForLaterResponse.fromJson(body);
    return result;
  }

  Future<BookNotes> getSavedNotesForLater(
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["save-note"]}/$userId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    BookNotes result = BookNotes.fromJson(body["data"]);
    return result;
  }

  Future<DeleteSavedNoteResponse> deleteSavedNote(
    int noteId,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.delete(
      Uri.parse('${env["URL"]}${endpoints["save-note"]}/$noteId/$userId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    DeleteSavedNoteResponse result = DeleteSavedNoteResponse.fromJson(body);
    return result;
  }

  Future<IsSavedNoteResponse> isSavedNote(
    int noteId,
    String userId,
    String token,
  ) async {
    final env = await accessENV(assetFileName: '.env');
    apiHeader["Authorization"] = 'Bearer $token';
    apiHeader["userId"] = userId;
    var response = await http.get(
      Uri.parse('${env["URL"]}${endpoints["is-saved-note"]}/$noteId/$userId'),
      headers: apiHeader,
    );
    var body = jsonDecode(response.body);
    IsSavedNoteResponse result = IsSavedNoteResponse.fromJson(body);
    return result;
  }
}
