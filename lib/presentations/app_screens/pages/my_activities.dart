import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/models/comment.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/data/services/comments.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/edit_note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyActivitiesPage extends StatefulWidget {
  const MyActivitiesPage({super.key});

  @override
  State<MyActivitiesPage> createState() => _MyActivitiesPageState();
}

class _MyActivitiesPageState extends State<MyActivitiesPage> {
  String _userId = '';
  String _token = '';
  final int _notesMaxLines = 10;
  // Service variables
  BookNotesApi bookNotesApi = BookNotesApi();
  CommentsApi commentsApi = CommentsApi();
  List<Map<String, dynamic>> myNotes = [];
  List<Map<String, dynamic>> myComments = [];
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
    getMyNotesDo();
    getMyCommentsDo();
  }

  Future<void> getMyNotesDo() async {
    BookNotes data = await bookNotesApi.getNoteByQuery(
      {
        "userId": _userId,
        "limit": 100,
        "offset": 0,
      },
      _userId,
      _token,
    );
    setState(() {
      myNotes.clear();
      myNotes.addAll(data.data);
      _isApiLoading = false;
    });
  }

  Future<void> getMyCommentsDo() async {
    Comments data = await commentsApi.getCommentsByQuery(
      {
        "userId": _userId,
        "noteId": "",
        "limit": 100,
        "offset": 0,
      },
      _userId,
      _token,
    );
    setState(() {
      myComments.clear();
      myComments.addAll(data.data);
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
          await getMyNotesDo();
          await getMyCommentsDo();
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
                        'Your notes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      notesViewList(myNotes),
                      const SizedBox(
                        height: 14.0,
                      ),
                      Text(
                        'Your comments',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      myCommentsList(myComments),
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
          'Create your first note',
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
              Get.to(
                () => EditNotePage(
                  noteId: notes[index]["id"],
                  bookId: notes[index]["bookId"],
                  bookName: notes[index]["bookName"],
                  author: notes[index]["author"],
                  note: notes[index]["notes"],
                  isPrivate: notes[index]["isPrivate"],
                ),
              );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Text(
                              notes[index]["bookName"],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          notes[index]["author"],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
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
                          notes[index]["comments"] <= 1
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

  Widget myCommentsList(List comments) {
    if (comments.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
        alignment: Alignment.center,
        child: Text(
          'You have not commented on any notes yet!',
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
          final commentId = comments[index]["id"];
          return Dismissible(
            key: Key(commentId.toString()),
            onDismissed: (direction) {
              setState(() {
                comments.removeAt(index);
              });
            },
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
              padding: const EdgeInsets.only(right: 14.0),
              color: Colors.red,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
                      comments[index]["comment"],
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
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
            ),
          );
        },
      );
    }
  }
}
