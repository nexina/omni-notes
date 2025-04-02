import 'package:flutter/material.dart';

import 'package:omni_notes/resources.dart';

import 'package:omni_notes/view_controller/notes_vc.dart';
import 'package:omni_notes/view_controller/todolist_vc.dart';
import 'package:omni_notes/view_controller/quill_vc.dart';
import 'package:omni_notes/view_controller/reminder_vc.dart';

import 'package:omni_notes/view/mainwindow/android.dart';
import 'package:omni_notes/view/mainwindow/desktop.dart';

class MainWindowViewController extends StatefulWidget {
  const MainWindowViewController({super.key});

  @override
  State<MainWindowViewController> createState() =>
      _MainWindowViewControllerState();
}

class _MainWindowViewControllerState extends State<MainWindowViewController>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ToDoListViewControllerState> todolistKey = GlobalKey();
  final GlobalKey<NotesListViewControllerState> noteKey = GlobalKey();
  final GlobalKey<ReminderListViewControllerState> reminderKey = GlobalKey();

  late TabController tabController;

  // 0: Notes, 1: ToDoList, 2: Reminder , checks which tab the user is working on
  int index = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(handleTabSelection);
  }

  @override
  void dispose() {
    tabController.removeListener(handleTabSelection);
    tabController.dispose();
    super.dispose();
  }

  /* 
  Change index based on tab selection, 
  - only for android 
  */
  void handleTabSelection() {
    index = tabController.index;
    setState(() {});
  }

  /* 
  Change index based on button selection
  - only for desktop 
  */
  void changeIndex(int i) {
    index = i;
    setState(() {});
  }

  void createNTR(BuildContext context) {
    switch (index) {
      case 0:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuillViewController(
                onNoteAdded: (title, content, time) {
                  noteKey.currentState?.addNote(title, content, time);
                },
              ),
            ),
          );
        }
        break;
      case 1:
        {
          todolistKey.currentState?.addTask();
        }
        break;
      case 2:
        {
          reminderKey.currentState?.addReminder();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return (Resources.isMobile(width))
        ? AndroidMainWindowView(
            createNTR: createNTR,
            tabController: tabController,
            todolistKey: todolistKey,
            noteKey: noteKey,
            reminderKey: reminderKey,
          )
        : DesktopMainWindowView(
            changeIndex: changeIndex,
            createNTR: createNTR,
            tabController: tabController,
            todolistKey: todolistKey,
            noteKey: noteKey,
            reminderKey: reminderKey,
          );
  }
}
