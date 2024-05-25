import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/note_page.dart';
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
  List<Map<String, dynamic>> myNotes = [];
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
  }

  Future<void> getMyNotesDo() async {
    BookNotes data = await bookNotesApi.getNoteByQuery(
      {
        "userId": _userId,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        displacement: Scaffold.of(context).appBarMaxHeight ?? 40.0,
        onRefresh: () async {
          await getMyNotesDo();
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
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      notesViewList(myNotes),
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
              Get.to(() => NotePage(noteId: notes[index]["id"]));
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
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
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
                                color: Theme.of(context).colorScheme.secondary,
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
          );
        },
      );
    }
  }
}
