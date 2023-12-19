import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_notes/resources.dart';

class Quill extends StatefulWidget {
  String? getTitle;
  String? getContent;
  String? getTime;
  int? getIndex;
  Function(String, String, String)? onNoteAdded;
  Function(String, String, String, int)? onNoteChange;
  Quill({
    super.key,
    this.onNoteAdded,
    this.getTitle,
    this.getContent,
    this.getTime,
    this.getIndex,
    this.onNoteChange,
  });

  @override
  State<Quill> createState() => QuillState();
}

class QuillState extends State<Quill> {
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  String noteTitle = "";
  String noteContent = "";
  String noteTime =
      DateFormat("dd MMMM yyyy, hh:mm a").format(DateTime.now()).toString();

  @override
  void initState() {
    super.initState();
    if (widget.getTitle != null) {
      titleController.text = widget.getTitle!;
      noteTitle = widget.getTitle!;
    }
    if (widget.getContent != null) {
      noteController.text = widget.getContent!;
      noteContent = widget.getContent!;
    }

    if (widget.getTime == null) {
      noteTime =
          DateFormat("dd MMMM yyyy, hh:mm a").format(DateTime.now()).toString();
    } else {
      noteTime = widget.getTime!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: Resources().getImageProvider(Resources.BackgroundImage),
            fit: BoxFit.cover,
          )),
          child: Center(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(163, 20, 20, 20),
              ),
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 5.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                if (noteController.text != "") {
                                  setState(() {
                                    noteContent = noteController.text;

                                    if (titleController.text == "") {
                                      noteTitle = "New Note";
                                    } else {
                                      noteTitle = titleController.text;
                                    }

                                    if (widget.onNoteAdded != null) {
                                      widget.onNoteAdded!(
                                          noteTitle, noteContent, noteTime);
                                    } else {
                                      widget.onNoteChange!(
                                          noteTitle,
                                          noteContent,
                                          noteTime,
                                          widget.getIndex!);
                                    }
                                  });
                                } else {
                                  var snackBar = SnackBar(
                                      backgroundColor:
                                          Resources.secondaryBackgroundColor,
                                      content: const Text(
                                        'Note has not been saved',
                                        style:
                                            TextStyle(fontFamily: "Inria Sans"),
                                      ));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextField(
                                      controller: titleController,
                                      showCursor: false,
                                      maxLines: 1,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        hintText: "New Note",
                                        hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 166, 166, 166),
                                          fontFamily: "Inria Sans",
                                        ),
                                        border: InputBorder.none,
                                        //isDense: true,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 2),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 17.0,
                                        fontFamily: "Inria Sans",
                                      ),
                                    ),
                                    Text(noteTime,
                                        style: const TextStyle(fontSize: 10.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: noteController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Write your thoughts...",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(150, 173, 173, 173),
                              fontFamily: "Inria Sans",
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Resources.primaryTextColor,
                            backgroundColor: Colors.transparent,
                            fontSize: 15.0,
                            fontFamily: "Inria Sans",
                          ),
                          cursorColor: const Color.fromARGB(255, 79, 79, 79),
                        ),
                      )),
                    ]),
              ),
            ),
          ))),
    );
  }
}
