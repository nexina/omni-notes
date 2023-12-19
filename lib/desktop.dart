import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:omni_notes/notes.dart';
import 'package:omni_notes/quill.dart';
import 'package:omni_notes/reminder.dart';
import 'package:omni_notes/resources.dart';
import 'package:omni_notes/settings.dart';
import 'package:omni_notes/todolist.dart';

class DesktopMain extends StatefulWidget {
  const DesktopMain({super.key});

  @override
  State<DesktopMain> createState() => _DesktopMainState();
}

class _DesktopMainState extends State<DesktopMain> {
  final GlobalKey<ToDoListState> todolistKey = GlobalKey();
  final GlobalKey<NotesListState> noteKey = GlobalKey();
  final GlobalKey<ReminderListState> reminderKey = GlobalKey();

  void create(BuildContext context, int index) {
    switch (index) {
      case 0:
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Quill(
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
          //createNewTask(context);
          todolistKey.currentState?.addNewTask();
        }
        break;
      case 2:
        {
          // Show AddReminderDialog
          reminderKey.currentState?.addReminder();
        }
        break;
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
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: const Color(0x00242424).withOpacity(0.5),
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
                                Expanded(child: NotesList(key: noteKey)),
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
                                                //textAlign: TextAlign.center,
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
                                            create(context, 0);
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
                            //width: (MediaQuery.of(context).size.width / 2) - 60,
                            margin: const EdgeInsets.only(
                                top: 20.0,
                                left: 10.0,
                                right: 20.0,
                                bottom: 10.0),

                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    //width: (MediaQuery.of(context).size.width / 2) - 60,
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
                                            child: ToDoList(key: todolistKey)),
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
                                                    create(context, 1);
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
                                    //width: (MediaQuery.of(context).size.width / 2) - 60,
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
                                            child:
                                                ReminderList(key: reminderKey)),
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
                                                    create(context, 2);
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
                              builder: (context) => const Settings(),
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
