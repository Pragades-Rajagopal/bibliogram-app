import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/models/comment.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/data/services/comments.dart';
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
  // Service
  BookNotesApi bookNotesApi = BookNotesApi();
  BookNote? bookNote;
  CommentsApi commentsApi = CommentsApi();
  List<Map<String, dynamic>> comments = [];

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
    await getNoteByIdDo(widget.noteId);
    await getCommentsForNote(widget.noteId);
  }

  Future<void> getNoteByIdDo(int noteId) async {
    bookNote = await bookNotesApi.getNoteById(noteId, _userId, _token);
  }

  Future<void> getCommentsForNote(int noteId) async {
    Comments data = await commentsApi.getCommentsByQuery(
      {
        "noteId": widget.noteId,
        "limit": 100,
        "offset": 0,
      },
      _userId,
      _token,
    );
    setState(() {
      comments.clear();
      comments.addAll(data.data);
    });
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
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'Notes about ',
                    ),
                    TextSpan(
                      text: '${bookNote?.bookName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' by ',
                    ),
                    TextSpan(
                      text: '${bookNote?.author}',
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
                        'From ${bookNote?.user}',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${bookNote?.shortDate}',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                'Comments (${comments.length})',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              commentsList(comments),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentsList(List comments) {
    if (comments.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
        alignment: Alignment.center,
        child: Text(
          'No comments available for this note',
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
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return Card(
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
                    comments[index]["comment"],
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            comments[index]["user"],
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        comments[index]["shortDate"],
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
          );
        },
      );
    }
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
