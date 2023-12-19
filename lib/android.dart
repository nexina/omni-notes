import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:omni_notes/notes.dart';
import 'package:omni_notes/quill.dart';
import 'package:omni_notes/reminder.dart';
import 'package:omni_notes/resources.dart';
import 'package:omni_notes/settings.dart';
import 'package:omni_notes/todolist.dart';

class AndroidMain extends StatefulWidget {
  const AndroidMain({super.key});

  @override
  State<AndroidMain> createState() => _AndroidMainState();
}

class _AndroidMainState extends State<AndroidMain>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ToDoListState> todolistKey = GlobalKey();
  final GlobalKey<NotesListState> noteKey = GlobalKey();
  final GlobalKey<ReminderListState> reminderKey = GlobalKey();

  late TabController tabController;
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

  void handleTabSelection() {
    index = tabController.index;
    setState(() {});
  }

  void create(BuildContext context) {
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
          todolistKey.currentState?.addNewTask();
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
    double winWidth = MediaQuery.of(context).size.width;
    double winHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        // Background Image
        decoration: BoxDecoration(
            image: DecorationImage(
          image: Resources().getImageProvider(Resources.BackgroundImage),
          fit: BoxFit.cover,
        )),
        child: BackdropFilter(
          // Blur Background
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            // Blur Color
            color: const Color(0x00242424).withOpacity(0.5),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        width: winWidth,
                        //height: (winHeight * 9.3 / 10) - 20.0,
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
                            Container(
                              width: winWidth,
                              child: Center(
                                child: TabBar(
                                  // Tab Bar
                                  controller: tabController,
                                  tabAlignment: TabAlignment.center,
                                  indicatorColor: Resources.secondaryLineColor,
                                  //dividerColor: Resources.primaryLineColor,
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
                                  controller: tabController,
                                  // Tab View
                                  children: [
                                    NotesList(key: noteKey),
                                    ToDoList(key: todolistKey),
                                    ReminderList(key: reminderKey)
                                  ]),
                            ),
                            Container(
                              // ADD Button COntainer
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
                                  create(context);
                                },
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size.square(40)),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 30.0)),
                                  shape: MaterialStateProperty.all(
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
                    // OMNI written
                    width: winWidth,
                    height: winHeight * 0.7 / 10,
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
            ),
          ),
        ),
      ),
    );
  }
}
