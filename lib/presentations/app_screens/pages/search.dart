import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/search.dart';
import 'package:bibliogram_app/data/services/search.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/book_page.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  String _token = '';
  String _userId = '';
  SearchApi searchApi = SearchApi();
  List<dynamic> searchResult = [];
  int searchResultCount = 0;
  String _searchValue = '';
  bool _searchResultVisibility = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      searchResult.clear();
      _searchValue = '';
    });
    initStateMethods();
  }

  void initStateMethods() async {
    final userData = await UserToken.getStoreTokenData();
    setState(() {
      _userId = userData["id"];
      _token = userData["token"];
    });
  }

  Future<void> getSearchResult(String value) async {
    SearchResult result = await searchApi.globalSearch(value, _userId, _token);
    searchResult.clear();
    searchResult.addAll(result.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    hintText: 'Search something...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    prefixIcon: IconButton(
                      color: Theme.of(context).colorScheme.secondary,
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        textController.text = '';
                      },
                    ),
                    suffixIcon: IconButton(
                      color: Theme.of(context).colorScheme.secondary,
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (textController.text != '') {
                          setState(() {
                            _searchValue = textController.text;
                            _searchResultVisibility = true;
                          });
                        }
                      },
                    ),
                  ),
                  cursorColor: Theme.of(context).colorScheme.tertiary,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onSubmitted: (data) {
                    if (textController.text != '') {
                      setState(() {
                        _searchValue = textController.text;
                        _searchResultVisibility = true;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_searchResultVisibility) ...{
                searchResultBuilder(_searchValue),
              }
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> searchResultBuilder(String value) {
    return FutureBuilder(
      future: getSearchResult(value),
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (searchResult.isEmpty) {
              return Center(
                child: Text(
                  "No result for the search",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return searchResultView(searchResult);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        } catch (e) {
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }

  Widget searchResultView(List searchResult) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (searchResult[index]["type"] == 'book') {
              Get.to(() => BookPage(bookId: searchResult[index]["id"]));
            } else if (searchResult[index]["type"] == 'note') {
              Get.to(() => NotePage(noteId: searchResult[index]["id"]));
            }
          },
          child: Card(
            color: Theme.of(context).colorScheme.background,
            margin: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 5.0,
            ),
            shape: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            shadowColor: Colors.transparent,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Text(
                      searchResult[index]["type"],
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  if (searchResult[index]["type"] == 'note') ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Text(
                              searchResult[index]["field3"],
                              style: TextStyle(
                                fontSize: 16.0,
                                // fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          searchResult[index]["field4"],
                          style: TextStyle(
                            fontSize: 16.0,
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  },
                  if (searchResult[index]["type"] == 'book') ...{
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                      child: Text(
                        searchResult[index]["field1"],
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  } else if (searchResult[index]["type"] == 'note') ...{
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                      child: Text(
                        searchResult[index]["field1"],
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  },
                  if (searchResult[index]["type"] == 'book') ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 14, 6),
                            child: Text(
                              searchResult[index]["field4"],
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          searchResult[index]["field5"] == 0
                              ? 'No notes added'
                              : searchResult[index]["field5"] == 1
                                  ? '${searchResult[index]["field5"]} note added'
                                  : '${searchResult[index]["field5"]} notes added',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  },
                  if (searchResult[index]["type"] == 'note') ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Text(
                              searchResult[index]["field2"],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          searchResult[index]["field5"],
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
