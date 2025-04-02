import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omni_notes/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omni_notes/view/todolist/todolist.dart';

class ToDoListViewController extends StatefulWidget {
  const ToDoListViewController({Key? key}) : super(key: key);

  @override
  State<ToDoListViewController> createState() => ToDoListViewControllerState();
}

// List toDoList = [
//   ["Make Tutorial", false],
//   ["Do Stuff", false],
//   ["Do FUck", false],
// ];

List taskList = [];
List dummyList = [];

class ToDoListViewControllerState extends State<ToDoListViewController> {
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

  void addTask() {
    setState(() {
      List<String> newTask = ["", "0"];
      taskList.add(newTask);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
      saveToDoList();
    });
  }

  Future<void> loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedList = prefs.getString(Resources.keyTodoList);
    if (loadedList != null) {
      taskList = List<List<String>>.from(
          jsonDecode(loadedList).map((x) => List<String>.from(x)));
    }
  }

  Future<void> saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(Resources.keyTodoList, jsonEncode(taskList));
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
    return ToDoListView(
      searchController: searchController,
      scrollController: scrollController,
      searchList: searchList,
      checkSearch: checkSearch,
      taskList: taskList,
      dummyList: dummyList,
      deleteTask: deleteTask,
      changeCheckBoxValue: changeCheckBoxValue,
      changeTaskName: changeTaskName,
    );
  }
}
