import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/presentations/app_screens/base.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNotePage extends StatefulWidget {
  final int noteId;
  final int bookId;
  final String bookName;
  final String author;
  final String note;
  const EditNotePage({
    super.key,
    required this.noteId,
    required this.bookId,
    required this.bookName,
    required this.author,
    required this.note,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();
  String _userId = '';
  String _token = '';
  // Service
  BookNotesApi bookNotesApi = BookNotesApi();
  AddorUpdateResponse? addorUpdateResp;
  // Edit notes variables
  final noteController = TextEditingController();
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
      noteController.text = widget.note;
    });
  }

  Future<void> updateNoteDo(String note) async {
    addorUpdateResp = await bookNotesApi.addOrUpdateNote(
      {
        "note": note,
        "userId": _userId,
        "bookId": widget.bookId.toString(),
        "id": widget.noteId.toString(),
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
        '${alertDialog["updateNoteSuccess"]}',
        'success',
      );
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
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Editing notes on ',
                    ),
                    TextSpan(
                      text: widget.bookName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' by ',
                    ),
                    TextSpan(
                      text: widget.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
                  controller: noteController,
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              //         child: Text(
              //           'From ${bookNote?.user}',
              //           style: TextStyle(
              //             fontSize: 18.0,
              //             color: Theme.of(context).colorScheme.secondary,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Text(
              //       '${bookNote?.shortDate}',
              //       style: TextStyle(
              //         fontSize: 16.0,
              //         color: Theme.of(context).colorScheme.secondary,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
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
            if (_key.currentState!.validate()) {
              setState(() {
                updateNoteDo(noteController.text);
              });
              Get.offAll(() => const AppBasePage(index: 2));
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
            'Save',
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
