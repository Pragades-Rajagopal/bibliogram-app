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
