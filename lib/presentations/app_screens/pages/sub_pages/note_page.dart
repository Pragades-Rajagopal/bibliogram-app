import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final int noteId;
  const NotePage({
    super.key,
    required this.noteId,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String _userId = '';
  String _token = '';
  int _noteId = 0;
  // Service
  BookNotesApi bookNotesApi = BookNotesApi();
  BookNote? bookNote;

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
      _noteId = widget.noteId;
    });
    await getNoteByIdDo(_noteId);
  }

  Future<void> getNoteByIdDo(int noteId) async {
    bookNote = await bookNotesApi.getNoteById(noteId, _userId, _token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                        '${bookNote?.bookName}',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${bookNote?.author}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14.0,
              ),
              Text(
                '${bookNote?.notes}',
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
              const SizedBox(
                height: 14.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Text(
                        '${bookNote?.user}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${bookNote?.modifiedOn}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar _appBar = AppBar(
  title: const Text(
    'Bibliogram',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
  centerTitle: true,
);
