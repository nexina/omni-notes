import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:omni_notes/resources.dart';

import 'package:omni_notes/view_controller/notes_vc.dart';
import 'package:omni_notes/view_controller/todolist_vc.dart';
import 'package:omni_notes/view_controller/reminder_vc.dart';
import 'package:omni_notes/view_controller/settings_vc.dart';

/*
AndroidMainWindowView: AndroidMainWindowView is the main view for the Android version of the app. it's stateful because the background is changeable.
It contains a TabBar with three tabs: Notes, ToDoList, and Reminder.
Each tab has a corresponding view: NotesList, ToDoList, and ReminderList.
The view also contains a button to create a new note, to-do list, or reminder.
The view is styled with a background image and a blur effect.

TabController tabController: The TabController for the TabBar.
createNTR: A function that creates a new note, to-do list, or reminder.
GlobalKey<ToDoListState> todolistKey: A GlobalKey for the ToDoListState. Used to access the ToDoListState from the parent widget.
GlobalKey<NotesListState> noteKey: A GlobalKey for the NotesListState. Used to access the NotesListState from the parent widget.
GlobalKey<ReminderListState> reminderKey: A GlobalKey for the ReminderListState. Used to access the ReminderListState from the parent widget.
*/

class AndroidMainWindowView extends StatefulWidget {
  final TabController tabController;
  final Function createNTR;
  final GlobalKey<ToDoListViewControllerState> todolistKey;
  final GlobalKey<NotesListViewControllerState> noteKey;
  final GlobalKey<ReminderListViewControllerState> reminderKey;
  const AndroidMainWindowView(
      {super.key,
      required this.createNTR,
      required this.tabController,
      required this.todolistKey,
      required this.noteKey,
      required this.reminderKey});

  @override
  State<AndroidMainWindowView> createState() => _AndroidMainWindowViewState();
}

class _AndroidMainWindowViewState extends State<AndroidMainWindowView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
            color: const Color(0x00242424).withValues(alpha: 0.5),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23.0),
                          border: Border.all(
                            color: Resources.primaryLineColor,
                            width: 2.0,
                          ),
                        ),
                        margin: const EdgeInsets.only(
                            top: 20.0, bottom: 0.0, left: 17.0, right: 17.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: width,
                              child: Center(
                                child: TabBar(
                                  controller: widget.tabController,
                                  tabAlignment: TabAlignment.center,
                                  indicatorColor: Resources.secondaryLineColor,
                                  tabs: [
                                    Tab(
                                      icon: Image.asset(
                                        "images/Notes.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      height: 60,
                                    ),
                                    Tab(
                                      icon: Image.asset(
                                        "images/ToDoList.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      height: 60,
                                    ),
                                    Tab(
                                      icon: Image.asset(
                                        "images/Reminder.png",
                                        height: 25,
                                        width: 25,
                                      ),
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                  controller: widget.tabController,
                                  physics: const BouncingScrollPhysics(),
                                  children: [
                                    NotesListViewController(
                                        key: widget.noteKey),
                                    ToDoListViewController(
                                        key: widget.todolistKey),
                                    ReminderListViewController(
                                        key: widget.reminderKey)
                                  ]),
                            ),
                            Container(
                              height: 80,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Resources.primaryLineColor,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  widget.createNTR(context);
                                },
                                style: ButtonStyle(
                                  elevation: WidgetStateProperty.all(0),
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  minimumSize: WidgetStateProperty.all(
                                      const Size.square(40)),
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30.0)),
                                  shape: WidgetStateProperty.all(
                                      const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                  )),
                                ),
                                child: const Image(
                                    image: AssetImage("images/Add.png")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.7 / 10,
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
                          elevation: WidgetStateProperty.all(0),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.transparent),
                          minimumSize:
                              WidgetStateProperty.all(const Size.square(40)),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 30.0)),
                          shape: WidgetStateProperty.all(
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
            ),
          ),
        ),
      ),
    );
  }
}
