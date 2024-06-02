/// Model for Top books & Get book function
class Books {
  List<Map<String, dynamic>> data = [];
  Books.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "id": json[i]["id"],
        "name": json[i]["name"],
        "author": json[i]["author"],
        "summary": json[i]["summary"],
        "rating": json[i]["rating"],
        "pages": json[i]["pages"],
        "publishedOn": json[i]["published_on"],
        "createdOn": json[i]["_created_on"],
        "bookName": json[i]["book_name"],
        "notesCount": json[i]["notes_count"],
      });
    }
  }
}

/// Model for book lists for suggestion
class Book {
  List data = [];
  Book.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "id": json[i]["id"],
        "name": json[i]["name"],
      });
    }
  }
}
