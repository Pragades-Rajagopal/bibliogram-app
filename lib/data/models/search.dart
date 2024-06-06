class SearchResult {
  List<Map<String, dynamic>> data = [];

  SearchResult.fromJson(List<dynamic> json) {
    for (var i = 0; i < json.length; i++) {
      data.add({
        "type": json[i]["type"],
        "field1": json[i]["field1"],
        "field2": json[i]["field2"],
        "field3": json[i]["field3"],
        "field4": json[i]["field4"],
        "field5": json[i]["field5"],
      });
    }
  }
}
