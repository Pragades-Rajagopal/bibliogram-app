import 'package:bibliogram_app/configurations/constants.dart';
import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/models/comment.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/data/services/comments.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/edit_note.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/note_page.dart';
import 'package:bibliogram_app/presentations/utils/common.dart';
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
  final int _notesMaxLines = 6;
  // Service variables
  BookNotesApi bookNotesApi = BookNotesApi();
  CommentsApi commentsApi = CommentsApi();
  List<Map<String, dynamic>> myNotes = [];
  List<Map<String, dynamic>> savedNotes = [];
  List<Map<String, dynamic>> myComments = [];
  // State variables
  bool _myNotesisApiLoading = true;
  bool _savedNotesisApiLoading = true;

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
    await getMyNotesDo();
    await getMyCommentsDo();
    await getSavedNotesForLaterDo();
  }

  Future<void> getMyNotesDo() async {
    BookNotes data = await bookNotesApi.getNoteByQuery(
      {
        "userId": _userId,
        "bookId": '',
        "limit": 100,
        "offset": 0,
      },
      _userId,
      _token,
    );
    setState(() {
      myNotes.clear();
      myNotes.addAll(data.data);
      _myNotesisApiLoading = false;
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
      _myNotesisApiLoading = false;
    });
  }

  Future<void> getSavedNotesForLaterDo() async {
    BookNotes data = await bookNotesApi.getSavedNotesForLater(
      _userId,
      _token,
    );
    setState(() {
      savedNotes.clear();
      savedNotes.addAll(data.data);
      _savedNotesisApiLoading = false;
    });
  }

  Future<void> deleteCommentDo(int commentId) async {
    DeleteCommentResponse? deleteCommentResp = await commentsApi.deleteComment(
      commentId,
      _userId,
      _token,
    );
    if (deleteCommentResp.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else {
      showSnackBar(
        '${alertDialog["commonSuccess"]}',
        '${alertDialog["deleteCommentSuccess"]}',
        'success',
      );
    }
  }

  Future<void> deleteSavedNoteDo(int noteId) async {
    DeleteSavedNoteResponse? deleteResp = await bookNotesApi.deleteSavedNote(
      noteId,
      _userId,
      _token,
    );
    if (deleteResp.statusCode == statusCode["serverError"]) {
      showSnackBar(
        '${alertDialog["oops"]}',
        '${alertDialog["commonError"]}',
        'error',
      );
    } else {
      showSnackBar(
        '${alertDialog["commonSuccess"]}',
        '${alertDialog["savedNoteRemoved"]}',
        'success',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      myNotesSection(context),
      savedNotesSection(context),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            tabs: const [
              Tab(text: 'My Notes'),
              Tab(text: 'Saved Notes'),
            ],
            unselectedLabelColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: TabBarView(children: tabs),
      ),
    );
  }

  RefreshIndicator myNotesSection(BuildContext context) {
    return RefreshIndicator(
      displacement: Scaffold.of(context).appBarMaxHeight ?? 40.0,
      onRefresh: () async {
        await getMyNotesDo();
        await getMyCommentsDo();
      },
      color: Theme.of(context).colorScheme.secondary,
      child: _myNotesisApiLoading
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
                    const SizedBox(
                      height: 8.0,
                    ),
                    myNotesViewList(myNotes),
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
    );
  }

  RefreshIndicator savedNotesSection(BuildContext context) {
    return RefreshIndicator(
      displacement: Scaffold.of(context).appBarMaxHeight ?? 40.0,
      onRefresh: () async {
        await getSavedNotesForLaterDo();
      },
      color: Theme.of(context).colorScheme.secondary,
      child: _savedNotesisApiLoading
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
                    const SizedBox(
                      height: 8.0,
                    ),
                    savedNotesViewList(savedNotes),
                    const SizedBox(
                      height: 14.0,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// My notes list
  Widget myNotesViewList(List notes) {
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

  /// section defines if it belongs to My notes or Saved note
  Widget savedNotesViewList(List notes) {
    if (notes.isEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 14),
        alignment: Alignment.center,
        child: Text(
          'No notes saved yet',
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
          final noteId = notes[index]["id"];
          return GestureDetector(
            onTap: () {
              Get.to(() => NotePage(noteId: notes[index]["id"]))
                  ?.then((_) async {
                await getSavedNotesForLaterDo();
              });
            },
            child: Dismissible(
              key: Key(noteId.toString()),
              onDismissed: (direction) async {
                setState(() {
                  notes.removeAt(index);
                });
                await deleteSavedNoteDo(noteId);
              },
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                padding: const EdgeInsets.only(right: 14.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color.fromARGB(255, 246, 190, 106),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Remove',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
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
                                  color:
                                      Theme.of(context).colorScheme.secondary,
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
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        notes[index]["comments"] <= 1
                            ? '${notes[index]["comments"]} comment'
                            : '${notes[index]["comments"]} comments',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
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
                                notes[index]["user"],
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
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
            onDismissed: (direction) async {
              setState(() {
                comments.removeAt(index);
              });
              await deleteCommentDo(commentId);
            },
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 4),
              padding: const EdgeInsets.only(right: 14.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.red,
              ),
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
