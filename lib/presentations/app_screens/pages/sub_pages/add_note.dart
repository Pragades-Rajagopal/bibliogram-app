import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book.dart';
import 'package:bibliogram_app/data/services/book.dart';
import 'package:flutter/material.dart';

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
  List<String> books = [];
  // Add note variables
  final textController = TextEditingController();
  final bookController = TextEditingController();
  String selectedBook = '';
  static const _maxLines = 20;

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
    setState(() {
      books.addAll(data.data);
    });
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
                  width: 380.0,
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
                  width: 380.0,
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
                      hintText: 'Type note here',
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return textFieldErrors["mandatory"];
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 18.0,
                ),
              ],
            ),
          ),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Bibliogram',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
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
