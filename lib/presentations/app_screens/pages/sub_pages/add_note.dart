import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/presentations/app_screens/base.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  final GlobalKey<AutoCompleteTextFieldState<String>> _bookKey = GlobalKey();
  String _userId = '';
  String _token = '';
  // Service
  BooksApi booksApi = BooksApi();
  BookNotesApi bookNotesApi = BookNotesApi();
  List<Map<String, dynamic>> bookListWithMap = [];
  List<String> books = [];
  AddorUpdateResponse? addorUpdateResp;
  // Add note variables
  final textController = TextEditingController();
  final bookController = TextEditingController();
  String selectedBook = '';
  static const _maxLines = 20;
  bool _privateSwitchValue = true;

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
    await getBooks();
  }

  Future<void> getBooks() async {
    Book data = await booksApi.getAllBooks(_userId, _token);
    List<String> books_ = [];
    for (final i in data.data) {
      bookListWithMap.add(i);
      books_.add(i["name"]);
    }
    setState(() {
      books.addAll(books_);
    });
  }

  int getBookId(String name) {
    for (var book in bookListWithMap) {
      if (book['name'] == name) {
        return book['id'];
      }
    }
    return -1;
  }

  Future<void> addNoteDo(String note, int bookId, int isPrivate) async {
    addorUpdateResp = await bookNotesApi.addOrUpdateNote(
      {
        "note": note,
        "userId": _userId,
        "bookId": bookId.toString(),
        "id": "",
        "isPrivate": isPrivate.toString(),
      },
      _userId,
      _token,
    );
    if (addorUpdateResp?.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else if (addorUpdateResp?.statusCode == statusCode["success"]) {
      showSnackBar(
        '${alertDialog["commonSuccess"]}',
        '${alertDialog["addNoteSuccess"]}',
        'success',
      );
      Get.offAll(() => const AppBasePage(index: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: SimpleAutoCompleteTextField(
                    key: _bookKey,
                    controller: bookController,
                    suggestions: books,
                    clearOnSubmit: false,
                    suggestionsAmount: 6,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.all(12.0),
                      hintText: 'Search book',
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    textSubmitted: (data) {
                      if (bookController.text != '') {
                        setState(() {
                          selectedBook = bookController.text;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    key: _key,
                    maxLines: _maxLines,
                    controller: textController,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.all(12.0),
                      hintText: 'Write note here...',
                      hintStyle: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return textFieldErrors["mandatory"];
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Make this note private?',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      CupertinoSwitch(
                        value: _privateSwitchValue,
                        onChanged: (value) {
                          setState(() {
                            _privateSwitchValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
              ],
            ),
          ),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Add Note',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () async {
            if (_key.currentState!.validate()) {
              var bookId = getBookId(bookController.text);
              if (bookId == -1) {
                showSnackBar(
                  '${alertDialog["oops"]}',
                  '${alertDialog["invalidBook"]}',
                  'error',
                );
              } else {
                int isPrivate = _privateSwitchValue == true ? 1 : 0;
                await addNoteDo(textController.text, bookId, isPrivate);
              }
            }
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.fromLTRB(0, 4, 18, 0),
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
          ),
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.lightBlue,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    );
  }
}
