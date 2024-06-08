import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book.dart';
import 'package:bibliogram_app/data/services/book.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/book_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBooksPage extends StatefulWidget {
  const TopBooksPage({super.key});

  @override
  State<TopBooksPage> createState() => _TopBooksPageState();
}

class _TopBooksPageState extends State<TopBooksPage> {
  String _userId = '';
  String _token = '';
  // Service variables
  BooksApi booksApi = BooksApi();
  List<Map<String, dynamic>> booksList = [];
  // State variables
  bool _isApiLoading = true;

  switchLoadingIndicator() {
    setState(() {
      _isApiLoading = !_isApiLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    initStateMethods();
  }

  void initStateMethods() async {
    final userData = await UserToken.getStoreTokenData();
    setState(() {
      _userId = userData["id"];
      _token = userData["token"];
    });
    await getTopBooksDo();
  }

  Future<void> getTopBooksDo() async {
    Books books = await booksApi.getTopBooks(_userId, _token);
    setState(() {
      booksList.clear();
      booksList.addAll(books.data);
      _isApiLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        displacement: Scaffold.of(context).appBarMaxHeight ?? 40.0,
        onRefresh: () async {
          await getTopBooksDo();
        },
        child: _isApiLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Showing top ${booksList.length} books',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      topBooksList(booksList),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget topBooksList(List books) {
    if (books.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
        alignment: Alignment.center,
        child: Text(
          'Looks like there are no top books\nat the moment!',
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => BookPage(bookId: books[index]["id"]));
            },
            child: Card(
              color: Theme.of(context).colorScheme.background,
              margin: const EdgeInsets.symmetric(
                horizontal: 2.0,
                vertical: 4.0,
              ),
              shape: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              shadowColor: Colors.transparent,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books[index]["name"],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            books[index]["author"],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            books[index]["notesCount"] == 1
                                ? '${books[index]["notesCount"]} note added'
                                : '${books[index]["notesCount"]} notes added',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.navigate_next_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 28.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
