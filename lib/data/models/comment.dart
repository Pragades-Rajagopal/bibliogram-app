class Comments {
  List<Map<String, dynamic>> data = [];

  Comments.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "id": json[i]["id"],
        "userId": json[i]["user_id"],
        "noteId": json[i]["note_id"],
        "comment": json[i]["comment"],
        "createdOn": json[i]["created_on"],
        "user": json[i]["user"],
        "shortDate": json[i]["short_date"],
      });
    }
  }
}

class Comment {
  int? id;
  int? userId;
  int? noteId;
  String? comment;
  String? createdOn;
  String? user;
  String? shortDate;

  Comment({
    this.id,
    this.userId,
    this.noteId,
    this.comment,
    this.createdOn,
    this.user,
    this.shortDate,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    noteId = json["note_id"];
    comment = json["comment"];
    createdOn = json["created_on"];
    user = json["user"];
    shortDate = json["short_date"];
  }
}

class AddCommentResponse {
  int? statusCode;
  String? message;

  AddCommentResponse({
    this.statusCode,
    this.message,
  });

  AddCommentResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json["statusCode"];
    message = json["message"];
  }
}
