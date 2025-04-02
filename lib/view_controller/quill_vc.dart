import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_notes/view/quill/quill.dart';

class QuillViewController extends StatefulWidget {
  final String? getTitle;
  final String? getContent;
  final String? getTime;
  final int? getIndex;
  final Function(String, String, String)? onNoteAdded;
  final Function(String, String, String, int)? onNoteChange;
  const QuillViewController({
    super.key,
    this.onNoteAdded,
    this.getTitle,
    this.getContent,
    this.getTime,
    this.getIndex,
    this.onNoteChange,
  });

  @override
  State<QuillViewController> createState() => QuillViewControllerState();
}

class QuillViewControllerState extends State<QuillViewController> {
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  String noteTitle = "";
  String noteContent = "";
  String noteTime =
      DateFormat("dd MMMM yyyy, hh:mm a").format(DateTime.now()).toString();

  void changeNoteTitle(String title) {
    setState(() {
      noteTitle = title;
    });
  }

  void changeNoteContent(String content) {
    setState(() {
      noteContent = content;
    });
  }

  String getNoteTitle() {
    return noteTitle;
  }

  String getNoteContent() {
    return noteContent;
  }

  String getNoteTime() {
    return noteTime;
  }

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
    return QuillView(
        onNoteAdded: widget.onNoteAdded,
        onNoteChange: widget.onNoteChange,
        getIndex: widget.getIndex,
        noteController: noteController,
        titleController: titleController,
        changeNoteTitle: changeNoteTitle,
        changeNoteContent: changeNoteContent,
        getNoteTime: getNoteTime,
        getNoteTitle: getNoteTitle,
        getNoteContent: getNoteContent);
  }
}
