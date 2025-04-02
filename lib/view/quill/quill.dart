import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:omni_notes/resources.dart';

class QuillView extends StatefulWidget {
  final Function(String) changeNoteTitle;
  final Function(String) changeNoteContent;
  final Function getNoteTitle;
  final Function getNoteContent;
  final Function getNoteTime;
  final Function(String, String, String)? onNoteAdded;
  final Function(String, String, String, int)? onNoteChange;
  final int? getIndex;
  final TextEditingController noteController;
  final TextEditingController titleController;
  const QuillView({
    super.key,
    this.onNoteAdded,
    this.onNoteChange,
    this.getIndex,
    required this.noteController,
    required this.titleController,
    required this.changeNoteTitle,
    required this.changeNoteContent,
    required this.getNoteTime,
    required this.getNoteTitle,
    required this.getNoteContent,
  });

  @override
  State<QuillView> createState() => QuillViewState();
}

class QuillViewState extends State<QuillView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: Resources().getImageProvider(Resources.backgroundImage),
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
                                  if (widget.noteController.text != "") {
                                    setState(() {
                                      widget.changeNoteContent(
                                          widget.noteController.text);

                                      if (widget.titleController.text == "") {
                                        widget.changeNoteTitle("New Note");
                                      } else {
                                        widget.changeNoteTitle(
                                            widget.titleController.text);
                                      }

                                      if (widget.onNoteAdded != null) {
                                        widget.onNoteAdded!(
                                            widget.getNoteTitle(),
                                            widget.getNoteContent(),
                                            widget.getNoteTime());
                                      } else {
                                        widget.onNoteChange!(
                                            widget.getNoteTitle(),
                                            widget.getNoteContent(),
                                            widget.getNoteTime(),
                                            widget.getIndex!);
                                      }
                                    });
                                  } else {
                                    var snackBar = SnackBar(
                                        backgroundColor:
                                            Resources.secondaryBackgroundColor,
                                        content: const Text(
                                          'Note has not been saved',
                                          style: TextStyle(
                                              fontFamily: "Inria Sans"),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextField(
                                        controller: widget.titleController,
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
                                      Text(widget.getNoteTime(),
                                          style:
                                              const TextStyle(fontSize: 10.0)),
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
                            controller: widget.noteController,
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
      ),
    );
  }
}
