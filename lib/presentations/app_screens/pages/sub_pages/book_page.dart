import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookPage extends StatefulWidget {
  final int bookId;
  const BookPage({
    super.key,
    required this.bookId,
  });

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  String _userId = '';
  String _token = '';
  final int _notesMaxLines = 10;
  // Service variables
  BooksApi booksApi = BooksApi();
  BookNotesApi bookNotesApi = BookNotesApi();
  List<Map<String, dynamic>> bookInfo = [];
  List<Map<String, dynamic>> notesList = [];
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
    await getBookInfo(widget.bookId);
    await getNotesForBookDo(widget.bookId);
  }

  Future<void> getBookInfo(int bookId) async {
    Books book = await booksApi.getBookById(bookId, _userId, _token);
    setState(() {
      bookInfo.clear();
      bookInfo.addAll(book.data);
    });
  }

  Future<void> getNotesForBookDo(int bookId) async {
    BookNotes data = await bookNotesApi.getNoteByQuery(
      {
        "userId": "",
        "bookId": bookId.toString(),
        "limit": 100,
        "offset": 0,
      },
      _userId,
      _token,
    );
    setState(() {
      notesList.clear();
      notesList.addAll(data.data);
      _isApiLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await getBookInfo(widget.bookId);
          await getNotesForBookDo(widget.bookId);
        },
        color: Theme.of(context).colorScheme.secondary,
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
                        bookInfo[0]["name"],
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        bookInfo[0]["author"],
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (bookInfo[0]["summary"] != null) ...{
                        Text(
                          bookInfo[0]["summary"],
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      },
                      if (bookInfo[0]["rating"] != null) ...{
                        Text(
                          'Ratings - ${bookInfo[0]["rating"]}',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      },
                      if (bookInfo[0]["pages"] != null) ...{
                        Text(
                          bookInfo[0]["pages"] > 1
                              ? '${bookInfo[0]["pages"]} pages'
                              : '${bookInfo[0]["pages"]} page',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      },
                      const SizedBox(height: 20),
                      if (notesList.isNotEmpty) ...{
                        Text(
                          'Notes about this book',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      },
                      notesViewList(notesList),
                      Text(
                        'Note: Notes which are marked as private by the users will not appear here',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget notesViewList(List notes) {
    if (notes.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
        alignment: Alignment.center,
        child: Text(
          'No notes added for this book',
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
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => NotePage(noteId: notes[index]["id"]))
                  ?.then((_) async {
                await getNotesForBookDo(widget.bookId);
              });
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
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'From ${notes[index]["user"]}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      notes[index]["notes"],
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLines: _notesMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notes[index]["isPrivate"] == 1
                              ? 'Private note'
                              : notes[index]["comments"] <= 1
                                  ? '${notes[index]["comments"]} comment'
                                  : '${notes[index]["comments"]} comments',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          notes[index]["shortDate"],
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
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

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Book',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
    );
  }
}
