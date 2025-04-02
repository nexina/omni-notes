import 'package:flutter/material.dart';
import 'package:omni_notes/resources.dart';

class ToDoListView extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final Function(String) searchList;
  final Function(int) deleteTask;
  final Function(String, int) changeCheckBoxValue;
  final Function(String, int) changeTaskName;
  final FocusNode checkSearch;
  final List taskList;
  final List dummyList;
  const ToDoListView({
    super.key,
    required this.searchController,
    required this.scrollController,
    required this.searchList,
    required this.checkSearch,
    required this.taskList,
    required this.dummyList,
    required this.deleteTask,
    required this.changeCheckBoxValue,
    required this.changeTaskName,
  });

  @override
  State<ToDoListView> createState() => ToDoListViewState();
}

class ToDoListViewState extends State<ToDoListView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.searchController,
          onChanged: (value) {
            setState(() {
              widget.searchList(value);
            });
          },
          focusNode: widget.checkSearch,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "SEARCH",
            hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), letterSpacing: 5),
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
          child: (widget.taskList.isEmpty)
              ? Center(
                  child: Text("Nothing To Do",
                      style: TextStyle(
                        color: Resources.tertiaryTextColor,
                        fontSize: 15,
                        fontFamily: "Inria Sans",
                      )),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  controller: widget.scrollController,
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: widget.dummyList.length,
                  itemBuilder: (context, index) {
                    return ToDoListItem(
                      taskName: widget.dummyList[index][0],
                      taskCompleted: widget.dummyList[index][1],
                      onChanged: (value) {
                        String valStr;
                        if (value == true) {
                          valStr = "1";
                        } else {
                          valStr = "0";
                        }

                        setState(() {
                          widget.changeCheckBoxValue(valStr, index);
                        });
                      },
                      onDelete: () => widget.deleteTask(index),
                      updateTask: (taskName) {
                        widget.changeTaskName(taskName, index);
                      },
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
