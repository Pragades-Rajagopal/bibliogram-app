import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/models/comment.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/data/services/comments.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
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
  AddCommentResponse? addCommentResp;
  // Add comment variables
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  static const _maxLines = 10;

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
        "userId": "",
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

  Future<void> addCommentDo(String comment, int noteId) async {
    addCommentResp = await commentsApi.addComment(
      {
        "comment": comment,
        "userId": _userId,
        "noteId": noteId,
      },
      _userId,
      _token,
    );
    if (addCommentResp?.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else if (addCommentResp?.statusCode == statusCode["success"]) {
      showSnackBar(
        '${alertDialog["commonSuccess"]}',
        '${alertDialog["addCommentSuccess"]}',
        'success',
      );
      await getNoteByIdDo(widget.noteId);
      await getCommentsForNote(widget.noteId);
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
                    height: 10.0,
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
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 480,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add comment',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: _maxLines * 24,
                      child: TextFormField(
                        maxLines: _maxLines,
                        controller: textController,
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          errorStyle: const TextStyle(
                            fontSize: 18.0,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF0000),
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return textFieldErrors["add_comment_mandatory"];
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 14.0),
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addCommentDo(textController.text, widget.noteId);
                          setState(() {
                            textController.text = "";
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            MaterialStatePropertyAll(Colors.transparent),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        // Close the bottom sheet
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 32.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Note',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            _showBottomSheet(context);
          },
          style: const ButtonStyle(
            padding: MaterialStatePropertyAll(
              EdgeInsets.fromLTRB(0, 4, 18, 0),
            ),
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
          ),
          child: const Text(
            'Comment',
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
