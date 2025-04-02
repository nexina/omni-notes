import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:omni_notes/resources.dart';

import 'package:omni_notes/view_controller/settings_vc.dart';
import 'package:omni_notes/view_controller/notes_vc.dart';
import 'package:omni_notes/view_controller/todolist_vc.dart';
import 'package:omni_notes/view_controller/reminder_vc.dart';

/*
DesktopMainWindowView: DesktopMainWindowView is the main view for the Android version of the app. it's stateful because the background is changeable.
It contains a TabBar with three tabs: Notes, ToDoList, and Reminder.
Each tab has a corresponding view: NotesList, ToDoList, and ReminderList.
The view also contains a button to create a new note, to-do list, or reminder.
The view is styled with a background image and a blur effect.

TabController tabController: The TabController for the TabBar.
createNTR: A function that creates a new note, to-do list, or reminder.
changeIndex: changes  the index of working tab.
GlobalKey<ToDoListState> todolistKey: A GlobalKey for the ToDoListState. Used to access the ToDoListState from the parent widget.
GlobalKey<NotesListState> noteKey: A GlobalKey for the NotesListState. Used to access the NotesListState from the parent widget.
GlobalKey<ReminderListState> reminderKey: A GlobalKey for the ReminderListState. Used to access the ReminderListState from the parent widget.
*/

class DesktopMainWindowView extends StatefulWidget {
  final TabController tabController;
  final Function createNTR;
  final Function changeIndex;
  final GlobalKey<ToDoListViewControllerState> todolistKey;
  final GlobalKey<NotesListViewControllerState> noteKey;
  final GlobalKey<ReminderListViewControllerState> reminderKey;
  const DesktopMainWindowView(
      {super.key,
      required this.changeIndex,
      required this.createNTR,
      required this.tabController,
      required this.todolistKey,
      required this.noteKey,
      required this.reminderKey});

  @override
  State<DesktopMainWindowView> createState() => _DesktopMainWindowViewState();
}

class _DesktopMainWindowViewState extends State<DesktopMainWindowView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: Resources().getImageProvider(Resources.backgroundImage),
          fit: BoxFit.cover,
        )),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: const Color(0x00242424).withValues(alpha: .5),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 20.0,
                                left: 20.0,
                                right: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23.0),
                              border: Border.all(
                                color: Resources.primaryLineColor,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                    child: NotesListViewController(
                                        key: widget.noteKey)),
                                SizedBox(
                                  height: 60,
                                  child: Row(children: [
                                    Expanded(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Row(
                                        children: [
                                          Image(
                                            image: Resources().getImageProvider(
                                                "images/Notes.png"),
                                            width: 15,
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text("Notes",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Resources
                                                      .tertiaryTextColor,
                                                  fontFamily: "Inria Sans",
                                                )),
                                          ),
                                        ],
                                      ),
                                    )),
                                    SizedBox(
                                      width: 60,
                                      child: IconButton(
                                          onPressed: () {
                                            widget.changeIndex(0);
                                            widget.createNTR(context);
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Resources.primaryLineColor,
                                          )),
                                    )
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: 20.0,
                                left: 10.0,
                                right: 20.0,
                                bottom: 10.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(23.0),
                                      border: Border.all(
                                        color: Resources.primaryLineColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: ToDoListViewController(
                                                key: widget.todolistKey)),
                                        SizedBox(
                                          height: 60,
                                          child: Row(children: [
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: Resources()
                                                        .getImageProvider(
                                                            "images/ToDoList.png"),
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Text("To Do List",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Resources
                                                              .tertiaryTextColor,
                                                          fontFamily:
                                                              "Inria Sans",
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            )),
                                            SizedBox(
                                              width: 60,
                                              child: IconButton(
                                                  onPressed: () {
                                                    widget.changeIndex(1);
                                                    widget.createNTR(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Resources
                                                        .primaryLineColor,
                                                  )),
                                            )
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 0.0,
                                        right: 0.0,
                                        bottom: 0.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(23.0),
                                      border: Border.all(
                                        color: Resources.primaryLineColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: ReminderListViewController(
                                                key: widget.reminderKey)),
                                        SizedBox(
                                          height: 60,
                                          child: Row(children: [
                                            Expanded(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: Resources()
                                                        .getImageProvider(
                                                            "images/Reminder.png"),
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Text("Reminders",
                                                        //textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Resources
                                                              .tertiaryTextColor,
                                                          fontFamily:
                                                              "Inria Sans",
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            )),
                                            SizedBox(
                                              width: 60,
                                              child: IconButton(
                                                  onPressed: () {
                                                    widget.changeIndex(2);
                                                    widget.createNTR(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.add,
                                                    size: 30,
                                                    color: Resources
                                                        .primaryLineColor,
                                                  )),
                                            )
                                          ]),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const SettingsViewController(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          minimumSize:
                              MaterialStateProperty.all(const Size.square(40)),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 30.0)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          )),
                        ),
                        child: Text(
                          "O M N I",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Resources.primaryTextColor,
                            fontFamily: "Inria Sans",
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
