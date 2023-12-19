import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omni_notes/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => ToDoListState();
}

// List toDoList = [
//   ["Make Tutorial", false],
//   ["Do Stuff", false],
//   ["Do FUck", false],
// ];

List taskList = [];
List dummyList = [];

class ToDoListState extends State<ToDoList> {
  // FUNCTIONS
  // Change Checkbox Value
  @override
  void initState() {
    super.initState();
    //resetPreferences();
    loadToDoList().then((_) {
      dummyList = taskList;
      setState(() {});
    });

    checkSearch.addListener(() {
      if (!checkSearch.hasFocus) {
        resetList();
        searchController.text = '';
      }
    });
  }

  void resetList() {
    setState(() {
      dummyList = taskList;
    });
  }

  void searchList(String searchText) {
    setState(() {
      dummyList = taskList
          .where((element) =>
              element[0].toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });

    setState(() {});
  }

  void changeCheckBoxValue(String value, int index) {
    setState(() {
      if (taskList[index][1] == "0") {
        taskList[index][1] = "1";
      } else {
        taskList[index][1] = "0";
      }
      if (value == "1") {
        var item = taskList[index];
        taskList.removeAt(index);
        taskList.add(item);
      }

      saveToDoList();
    });
  }

  // Change Task Name
  void changeTaskName(String value, int index) {
    setState(() {
      taskList[index][0] = value;
      saveToDoList();
    });
  }

  // Delete Task
  void deleteTask(int index) {
    setState(() {
      taskList.removeAt(index);
      saveToDoList();
    });
  }

  void addNewTask() {
    setState(() {
      List<String> newTask = ["", "0"];
      taskList.add(newTask);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
      saveToDoList();
    });
  }

  Future<void> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedList = prefs.getString(Resources.KEY_TODOLIST);
    if (loadedList != null) {
      taskList = List<List<String>>.from(
          jsonDecode(loadedList).map((x) => List<String>.from(x)));
    }
  }

  Future<void> saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Resources.KEY_TODOLIST, jsonEncode(taskList));
  }

  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  FocusNode checkSearch = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          // SEARCH Text Field
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchList(value);
            });
          },
          focusNode: checkSearch,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "SEARCH",
            hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.6), letterSpacing: 5),
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
          child: (taskList.isEmpty)
              ? Center(
                  child: Text("Nothing To Do",
                      style: TextStyle(
                        color: Resources.tertiaryTextColor,
                        //Color.fromARGB(255, 168, 168, 168),
                        fontSize: 15,
                        fontFamily: "Inria Sans",
                      )),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  controller: scrollController,
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: dummyList.length,
                  itemBuilder: (context, index) {
                    return ToDoListItem(
                      taskName: dummyList[index][0],
                      taskCompleted: dummyList[index][1],
                      onChanged: (value) {
                        String valStr;
                        if (value == true) {
                          valStr = "1";
                        } else {
                          valStr = "0";
                        }

                        setState(() {
                          changeCheckBoxValue(valStr, index);
                        });
                      },
                      onDelete: () => deleteTask(index),
                      updateTask: (taskName) {
                        changeTaskName(taskName, index);
                      },
                      //onEdit: () => changeTaskName(value, index),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class ToDoListItem extends StatefulWidget {
  final String taskName;
  final String taskCompleted;
  final Function(bool?)? onChanged;
  final Function(String) updateTask;
  final VoidCallback onDelete;

  const ToDoListItem(
      {super.key,
      required this.taskName,
      required this.taskCompleted,
      required this.onChanged,
      required this.updateTask,
      //required this.onEdit,
      required this.onDelete});

  @override
  State<ToDoListItem> createState() => _ToDoListItemState();
}

class _ToDoListItemState extends State<ToDoListItem> {
  TextEditingController taskNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.taskName;
  }

  @override
  void didUpdateWidget(ToDoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.taskName != oldWidget.taskName) {
      taskNameController.text = widget.taskName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: 50,
      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Resources.primaryLineColor,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                  color: Resources.primaryLineColor,
                  width: 1,
                )),
              ),
              child: Center(
                child: IconButton(
                    onPressed: () => widget.onDelete(),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Resources.primaryLineColor,
                    )),
              ),
            ),
            Expanded(
              child: Center(
                child: TextField(
                  controller: taskNameController,
                  onChanged: (value) => widget.updateTask(value),
                  maxLines: null,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "New Task",
                      hintStyle: TextStyle(
                        color: Color.fromARGB(150, 173, 173, 173),
                      ),
                      border: InputBorder.none),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Inria Sans",
                    decoration: (widget.taskCompleted == "1" ? true : false)
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationColor: const Color.fromARGB(255, 255, 0, 0),
                    decorationStyle: TextDecorationStyle.wavy,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 50,
              child: Center(
                child: Checkbox(
                    value: (widget.taskCompleted == "1" ? true : false),
                    onChanged: widget.onChanged,
                    side: BorderSide(
                      color: Resources.primaryLineColor,
                      width: 2,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
