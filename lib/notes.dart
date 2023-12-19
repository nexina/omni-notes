import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_notes/quill.dart';
import 'package:omni_notes/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => NotesListState();
}

// List noteList = [
//   ["New FORk", "CUntent", "12 December 2021, 12:00 AM"],
//   ["New", "bal", "30 September 2021, 10:31 AM"],
// ];

List noteList = [];
List dummyList = [];

class NotesListState extends State<NotesList> {
  @override
  void initState() {
    super.initState();
    loadNoteList().then((_) {
      dummyList = noteList;
      setState(() {});
    });

    checkSearch.addListener(() {
      if (!checkSearch.hasFocus) {
        resetList();
        searchController.text = '';
      }
    });

    // resetPreferences();
  }

  void resetList() {
    setState(() {
      dummyList = noteList;
    });
  }

  void searchList(String searchText) {
    setState(() {
      dummyList = noteList
          .where((element) =>
              element[0].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });

    setState(() {});
  }

  Future<void> loadNoteList() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedList = prefs.getString(Resources.KEY_NOTESLIST);
    if (loadedList != null) {
      noteList = List<List<String>>.from(
          jsonDecode(loadedList).map((x) => List<String>.from(x)));
    }
  }

  Future<void> saveNoteList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Resources.KEY_NOTESLIST, jsonEncode(noteList));
  }

  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void addNote(String title, String content, String date) {
    setState(() {
      noteList.add([title, content, date]);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
      saveNoteList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      noteList.removeAt(index);
      saveNoteList();
    });
  }

  void updateNote(String title, String content, String date, int index) {
    setState(() {
      noteList[index][0] = title;
      noteList[index][1] = content;
      noteList[index][2] = date;
      saveNoteList();
    });
  }

  TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  FocusNode checkSearch = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          // SEARCH Text Field
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchList(value);
            });
          },

          focusNode: checkSearch,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "SEARCH",
            hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.6), letterSpacing: 5),
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          style: TextStyle(
            color: Resources.primaryTextColor,
            backgroundColor: Colors.transparent,
            fontSize: 15.0,
            fontFamily: "Inria Sans",
          ),
          cursorColor: const Color.fromARGB(255, 201, 201, 201),
        ),
        Expanded(
          child: (dummyList.isEmpty)
              ? IntrinsicHeight(
                  child: Center(
                    child: Text(
                      "No Notes",
                      style: TextStyle(
                        color: Resources.tertiaryTextColor,
                        fontSize: 15,
                        fontFamily: "Inria Sans",
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.all(0),
                  itemCount: dummyList.length,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return NotesListItem(
                      title: dummyList[index][0],
                      content: dummyList[index][1],
                      dateString: dummyList[index][2],
                      index: index,
                      updateNoteItem: (title, content, time, index) {
                        updateNote(
                          title,
                          content,
                          time,
                          index,
                        );
                      },
                      onDelete: () {
                        deleteNote(index);
                      },
                    );
                  },
                ),
        )
      ],
    );
  }
}

class NotesListItem extends StatefulWidget {
  String title = "New Note";
  String content = "Content";
  String dateString = "12 December 2021, 12:00 AM";
  int index;
  VoidCallback onDelete;
  Function(String, String, String, int) updateNoteItem;
  NotesListItem(
      {super.key,
      required this.title,
      required this.content,
      required this.index,
      required this.updateNoteItem,
      required this.dateString,
      required this.onDelete});

  @override
  State<NotesListItem> createState() => _NotesListItemState();
}

class _NotesListItemState extends State<NotesListItem> {
  @override
  Widget build(BuildContext context) {
    DateTime dateFormat =
        DateFormat("dd MMMM yyyy, hh:mm a").parse(widget.dateString);
    int date = int.parse(DateFormat("dd").format(dateFormat));
    String month = DateFormat("MMM").format(dateFormat);
    int year = int.parse(DateFormat("yyyy").format(dateFormat));
    String time = DateFormat("hh:mm a").format(dateFormat);
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: 80,
      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
      //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Resources.primaryLineColor,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Quill(
                    getTitle: widget.title,
                    getContent: widget.content,
                    getIndex: widget.index,
                    getTime: widget.dateString,
                    onNoteChange: (title, content, time, index) {
                      widget.updateNoteItem(title, content, time, index);
                    }),
              ),
            );
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Delete'),
                      onTap: () {
                        Navigator.pop(context);
                        widget.onDelete();
                      },
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(0, 208, 29, 29),
            elevation: 0,
            padding: const EdgeInsets.all(0),
            //disabledForegroundColor: Colors.transparent,
            //shadowColor: Colors.transparent,
            //foregroundColor: Colors.transparent,
            //shape: const LinearBorder(side: BorderSide.none),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Resources.primaryLineColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        date.toString(),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: "Noto Serif Display",
                            height: 0,
                            color: Resources.primaryTextColor,
                            letterSpacing: 2),
                      ),
                      Text(
                        month.toUpperCase(),
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inria Sans",
                            color: Resources.secondaryTextColor,
                            letterSpacing: 2),
                      ),
                      Text(
                        year.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Inria Sans",
                            color: Resources
                                .tertiaryTextColor, //Color.fromARGB(255, 156, 156, 156),
                            letterSpacing: 2),
                      )
                    ]),
              ),
              Expanded(
                child: Container(
                  //decoration: BoxDecoration(color: Colors.black),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.length > 15
                            ? "${widget.title.substring(0, 15)}..."
                            : widget.title,
                        style: TextStyle(
                            color: Resources.primaryTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Inria Sans"),
                      ),
                      Text(
                        widget.content.length > 25
                            ? "${widget.content.substring(0, 25)}..."
                            : widget.content,
                        style: TextStyle(
                            color: Resources
                                .secondaryTextColor, //Color.fromARGB(255, 165, 165, 165),
                            fontSize: 12,
                            fontFamily: "Inria Sans"),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: const Icon(Icons.access_time_outlined,
                                  color: Color.fromARGB(255, 182, 182, 182),
                                  size: 10),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                  color: Resources
                                      .tertiaryTextColor, //Color.fromARGB(255, 165, 165, 165),
                                  fontSize: 10,
                                  fontFamily: "Inria Sans"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
