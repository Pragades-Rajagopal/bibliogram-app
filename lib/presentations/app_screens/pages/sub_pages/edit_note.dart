import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/presentations/app_screens/base.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNotePage extends StatefulWidget {
  final int noteId;
  final int bookId;
  final String bookName;
  final String author;
  final String note;
  final int isPrivate;
  const EditNotePage({
    super.key,
    required this.noteId,
    required this.bookId,
    required this.bookName,
    required this.author,
    required this.note,
    required this.isPrivate,
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
      noteController.text = widget.note;
      _privateSwitchValue = widget.isPrivate == 1 ? true : false;
    });
  }

  Future<void> updateNoteDo(String note, int isPrivate) async {
    addorUpdateResp = await bookNotesApi.addOrUpdateNote(
      {
        "note": note,
        "userId": _userId,
        "bookId": widget.bookId.toString(),
        "id": widget.noteId.toString(),
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
        '${alertDialog["updateNoteSuccess"]}',
        'success',
      );
    }
  }

  Future<void> deleteNoteDo(int noteId) async {
    DeleteNoteResponse deleteNoteResp = await bookNotesApi.deleteNote(
      noteId,
      _userId,
      _token,
    );
    if (deleteNoteResp.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else if (deleteNoteResp.statusCode == statusCode["success"]) {
      showSnackBar(
        '${alertDialog["commonSuccess"]}',
        '${alertDialog["deleteNoteSuccess"]}',
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
                width: 400.0,
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
                height: 18.0,
              ),
              TextButton(
                onPressed: () async {
                  _showBottomSheet(context);
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.fromLTRB(20, 4, 20, 4),
                  ),
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                ),
                child: Text(
                  'Delete note',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0.0,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 220,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Do you wish to delete this note permanently?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () async {
                    await deleteNoteDo(widget.noteId);
                    Get.offAll(() => const AppBasePage(index: 2));
                  },
                  style: const ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    // Close the bottom sheet
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 14.0),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Edit Note',
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
              int isPrivate = _privateSwitchValue == true ? 1 : 0;
              await updateNoteDo(noteController.text, isPrivate);
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
