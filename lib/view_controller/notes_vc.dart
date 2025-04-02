import 'package:flutter/material.dart';
import 'package:omni_notes/view/notes/notes.dart';
import 'package:omni_notes/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotesListViewController extends StatefulWidget {
  const NotesListViewController({super.key});

  @override
  State<NotesListViewController> createState() =>
      NotesListViewControllerState();
}

// List noteList = [
//   ["New Fork", "Content", "12 December 2021, 12:00 AM"],
//   ["New", "content", "30 September 2021, 10:31 AM"],
// ];

List noteList = [];
List dummyList = [];

class NotesListViewControllerState extends State<NotesListViewController> {
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
    final loadedList = prefs.getString(Resources.keyNotesList);
    if (loadedList != null) {
      noteList = List<List<String>>.from(
          jsonDecode(loadedList).map((x) => List<String>.from(x)));
    }
  }

  Future<void> saveNoteList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Resources.keyNotesList, jsonEncode(noteList));
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
  ScrollController scrollController = ScrollController();
  FocusNode checkSearch = FocusNode();
  @override
  Widget build(BuildContext context) {
    return NotesListView(
      searchController: searchController,
      checkSearch: checkSearch,
      searchList: searchList,
      scrollController: scrollController,
      addNote: addNote,
      deleteNote: deleteNote,
      updateNote: updateNote,
      dummyList: dummyList,
    );
  }
}
