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
  final ScrollController scrollController = ScrollController();
  String _userId = '';
  String _token = '';
  final int _notesMaxLines = 10;
  // Service variables
  BookNotesApi bookNotesApi = BookNotesApi();
  List<Map<String, dynamic>> globalNotes = [];
  // State variables
  bool _isApiLoading = true;
  final int _limit = 25;
  int _offset = 0;
  bool _hasFeedData = true;

  @override
  void initState() {
    super.initState();
    initStateMethods();
    pagination();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void pagination() {
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (_hasFeedData) {
          await globalBookNotesDo(_userId, _token, _limit, _offset);
        }
      }
    });
  }

  void initStateMethods() async {
    final userData = await UserToken.getStoreTokenData();
    setState(() {
      _userId = userData["id"];
      _token = userData["token"];
    });
    await globalBookNotesDo(_userId, _token, _limit, _offset);
  }

  Future<void> globalBookNotesDo(
    String userId,
    String token,
    int limit,
    int offset,
  ) async {
    BookNotes notes =
        await bookNotesApi.getGlobalNotes(userId, token, limit, offset);
    int localOffset = _offset + _limit;
    setState(() {
      globalNotes.addAll(notes.data);
      _isApiLoading = false;
      _offset = localOffset;
      if (notes.data.length < _limit) {
        _hasFeedData = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: RefreshIndicator(
        displacement: Scaffold.of(context).appBarMaxHeight ?? 40.0,
        onRefresh: () async {
          _isApiLoading = true;
          globalNotes.clear();
          _offset = 0;
          _hasFeedData = true;
          await globalBookNotesDo(_userId, _token, _limit, _offset);
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
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
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
        itemCount: notes.length + 1,
        itemBuilder: (context, index) {
          if (index < notes.length) {
            return GestureDetector(
              onTap: () {
                Get.to(() => NotePage(noteId: notes[index]["id"]))
                    ?.then((_) async {
                  setState(() {
                    _isApiLoading = true;
                    globalNotes.clear();
                    _offset = 0;
                    _hasFeedData = true;
                  });
                  await globalBookNotesDo(_userId, _token, _limit, _offset);
                });
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
            );
          } else {
            return Center(
              child: _hasFeedData
                  ? Text(
                      'Crunching the notes...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    )
                  : Text(
                      'That' 's it!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
            );
          }
        },
      );
    }
  }
}
