import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_notes/view_controller/quill_vc.dart';
import 'package:omni_notes/resources.dart';

class NotesListView extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final Function(String) searchList;
  final Function(String, String, String, int) updateNote;
  final FocusNode checkSearch;
  final List dummyList;
  final Function deleteNote;
  final Function addNote;
  const NotesListView({
    super.key,
    required this.searchController,
    required this.scrollController,
    required this.searchList,
    required this.updateNote,
    required this.checkSearch,
    required this.dummyList,
    required this.deleteNote,
    required this.addNote,
  });

  @override
  State<NotesListView> createState() => NotesListViewState();
}

class NotesListViewState extends State<NotesListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.searchController,
          onChanged: (value) {
            setState(() {
              widget.searchList(value);
            });
          },
          focusNode: widget.checkSearch,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "SEARCH",
            hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: .6), letterSpacing: 5),
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
          child: (widget.dummyList.isEmpty)
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
                  itemCount: widget.dummyList.length,
                  controller: widget.scrollController,
                  itemBuilder: (context, index) {
                    return NotesListItem(
                      title: widget.dummyList[index][0],
                      content: widget.dummyList[index][1],
                      dateString: widget.dummyList[index][2],
                      index: index,
                      updateNoteItem: (title, content, time, index) {
                        widget.updateNote(
                          title,
                          content,
                          time,
                          index,
                        );
                      },
                      onDelete: () {
                        widget.deleteNote(index);
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
  final String title;
  final String content;
  final String dateString;
  final int index;
  final VoidCallback onDelete;
  final Function(String, String, String, int) updateNoteItem;
  const NotesListItem(
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
    String date = DateFormat("dd").format(dateFormat);
    String month = DateFormat("MMM").format(dateFormat);
    String year = DateFormat("yyyy").format(dateFormat);
    String time = DateFormat("hh:mm a").format(dateFormat);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
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
                builder: (context) => QuillViewController(
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
                child: Column(children: [
                  Text(
                    date,
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
                    year,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Inria Sans",
                        color: Resources.tertiaryTextColor,
                        letterSpacing: 2),
                  )
                ]),
              ),
              Expanded(
                child: Container(
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
                            color: Resources.secondaryTextColor,
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
                                  color: Resources.tertiaryTextColor,
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
