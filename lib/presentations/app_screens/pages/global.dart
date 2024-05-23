import 'package:bibliogram_app/data/local_storage/data.dart';
import 'package:bibliogram_app/data/models/book_notes.dart';
import 'package:bibliogram_app/data/services/book_notes.dart';
import 'package:bibliogram_app/presentations/app_screens/pages/sub_pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalAppPage extends StatefulWidget {
  const GlobalAppPage({super.key});

  @override
  State<GlobalAppPage> createState() => _GlobalAppPageState();
}

class _GlobalAppPageState extends State<GlobalAppPage> {
  String _userId = '';
  String _token = '';
  final int _notesMaxLines = 10;
  // Service variables
  BookNotesApi bookNotesApi = BookNotesApi();
  List<Map<String, dynamic>> globalNotes = [];
  // State variables
  bool _isApiLoading = true;

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
    await globalBookNotesDo(_userId, _token);
  }

  Future<void> globalBookNotesDo(String userId, String token) async {
    GlobalBookNotes notes = await bookNotesApi.getGlobalNotes(userId, token);
    setState(() {
      globalNotes.clear();
      globalNotes.addAll(notes.data);
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
          await globalBookNotesDo(_userId, _token);
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
                      globalNotesListView(globalNotes),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget globalNotesListView(List notes) {
    if (notes.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          'No global notes available',
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
