class GlobalBookNotes {
  List<Map<String, dynamic>> data = [];

  GlobalBookNotes.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "id": json[i]["id"],
        "userId": json[i]["user_id"],
        "bookId": json[i]["book_id"],
        "notes": json[i]["notes"],
        "createdOn": json[i]["created_on"],
        "modifiedOn": json[i]["modified_on"],
        "isPrivate": json[i]["is_private"],
        "user": json[i]["user"],
        "bookName": json[i]["book_name"],
        "author": json[i]["author"],
      });
    }
  }
}

class BookNote {
  int? id;
  int? userId;
  int? bookId;
  String? notes;
  String? createdOn;
  String? modifiedOn;
  String? user;
  String? bookName;
  String? author;
  int? isPrivate;

  BookNote({
    this.id,
    this.userId,
    this.bookId,
    this.notes,
    this.createdOn,
    this.modifiedOn,
    this.user,
    this.bookName,
    this.author,
    this.isPrivate,
  });

  BookNote.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    userId = json["user_id"];
    bookId = json["book_id"];
    notes = json["notes"];
    createdOn = json["created_on"];
    modifiedOn = json["modified_on"];
    user = json["user"];
    bookName = json["book_name"];
    author = json["author"];
    isPrivate = json["is_private"];
  }
}
