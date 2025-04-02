import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_notes/resources.dart';

class ReminderListView extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final Function(String) searchList;
  final FocusNode checkSearch;
  final Function removeReminder;
  final Function saveToDoList;
  final Function(int) changeStatus;
  final Function(int id, String title, String time) updateNotification;
  const ReminderListView({
    super.key,
    required this.searchController,
    required this.scrollController,
    required this.searchList,
    required this.checkSearch,
    required this.removeReminder,
    required this.saveToDoList,
    required this.changeStatus,
    required this.updateNotification,
  });

  @override
  State<ReminderListView> createState() => ReminderListViewState();
}

class ReminderListViewState extends State<ReminderListView> {
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
          child: (remList.isEmpty)
              ? IntrinsicHeight(
                  child: Center(
                    child: Text(
                      "No Reminders",
                      style: TextStyle(
                        color: Resources
                            .tertiaryTextColor, //Color.fromARGB(255, 168, 168, 168),
                        fontSize: 15,
                        fontFamily: "Inria Sans",
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  controller: widget.scrollController,
                  physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: dummyList.length,
                  itemBuilder: (context, index) {
                    return ReminderListItem(
                      remTitle: dummyList[index][0],
                      remTime: dummyList[index][1],
                      remStatus: dummyList[index][2],
                      onDelete: () {
                        widget.removeReminder(index);
                      },
                      onStatusChange: () {
                        widget.changeStatus(index);
                      },
                      updateTitle: (value) {
                        setState(() {
                          remList[index][0] = value;
                          widget.updateNotification(
                              index, remList[index][0], remList[index][1]);
                          widget.saveToDoList();
                        });
                      },
                      updateTime: (value) {
                        setState(() {
                          remList[index][1] = value;
                          widget.updateNotification(
                              index, remList[index][0], remList[index][1]);
                          widget.saveToDoList();
                        });
                      },
                    );
                  },
                  padding: const EdgeInsets.all(0),
                ),
        )
      ],
    );
  }
}

// List remList = [
//   ["Do Jogging", "12 May 2021, 12:00 AM", "0"],
//   ["Do Something", "12 May 2061, 1:00 AM", "0"],
// ];

List remList = [];
List dummyList = [];

class ReminderListItem extends StatefulWidget {
  final String remTitle;
  final String remTime;
  final String remStatus;
  final VoidCallback onDelete;
  final VoidCallback onStatusChange;
  final Function(String) updateTitle;
  final Function(String) updateTime;
  const ReminderListItem({
    super.key,
    required this.remTitle,
    required this.remTime,
    required this.remStatus,
    required this.onDelete,
    required this.updateTitle,
    required this.updateTime,
    required this.onStatusChange,
  });

  @override
  State<ReminderListItem> createState() => _ReminderListItemState();
}

class _ReminderListItemState extends State<ReminderListItem> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();
  void selectTextInTitleController() {
    titleController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: titleController.text.length,
    );
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.remTitle;
    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus) {
        widget.updateTitle(titleController.text);
      }
    });
  }

  void updateReminder() {
    setState(() {
      if (widget.remStatus == "0") {
        setState(() {
          DateTime dateTime;
          DateTime initalDate =
              DateFormat("dd MMM yyyy, hh:mm a").parse(widget.remTime);
          TimeOfDay initalTime = TimeOfDay.fromDateTime(initalDate);
          showDatePicker(
            context: context,
            initialDate: initalDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 10),
          ).then((selectedDate) {
            if (selectedDate != null && mounted) {
              showTimePicker(context: context, initialTime: initalTime)
                  .then((selectedTime) {
                if (selectedTime != null) {
                  setState(() {
                    dateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute);

                    widget.updateTime(DateFormat("dd MMM yyyy, hh:mm a")
                        .format(dateTime)
                        .toString());

                    widget.onStatusChange();
                  });
                }
              });
            }
          });
        });
      } else {
        widget.onStatusChange();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime remdt = DateFormat("dd MMM yyyy, hh:mm a").parse(widget.remTime);
    return Container(
      width: MediaQuery.of(context).size.width,
      //height: 80,
      margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Resources.primaryLineColor,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.select_all),
                            title: const Text('Select Reminder Title'),
                            onTap: () {
                              Navigator.pop(context);
                              selectTextInTitleController();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete),
                            title: const Text('Delete'),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onDelete();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.transparent,
                  minimumSize: const Size.square(30),
                  padding: const EdgeInsets.all(0),
                  shadowColor: Colors.transparent,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        child: TextField(
                            controller: titleController,
                            focusNode: titleFocusNode,
                            // onChanged: (value) {
                            //   widget.updateTitle(value);
                            // },
                            //autofocus: true,
                            decoration: const InputDecoration(
                              hintText: "New Reminder",
                              hintStyle: TextStyle(
                                color: Color.fromARGB(128, 255, 255, 255),
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.all(4),
                            ),
                            style: TextStyle(
                                color: Resources.primaryTextColor,
                                fontSize: 18,
                                fontFamily: "Inria Sans")),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: const Icon(Icons.timer_outlined,
                                color: Color.fromARGB(255, 182, 182, 182),
                                size: 10),
                          ),
                          Text(
                            DateFormat("hh:mm a").format(remdt).toString(),
                            style: TextStyle(
                                color: Resources
                                    .secondaryTextColor, //Color.fromARGB(255, 182, 182, 182),
                                fontSize: 10,
                                fontFamily: "Inria Sans"),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                right: 5, top: 5, bottom: 5, left: 10),
                            child: const Icon(Icons.calendar_today_outlined,
                                color: Color.fromARGB(255, 182, 182, 182),
                                size: 10),
                          ),
                          Text(
                            DateFormat("dd MMM yyyy").format(remdt).toString(),
                            style: TextStyle(
                                color: Resources
                                    .secondaryTextColor, //Color.fromARGB(255, 182, 182, 182),
                                fontSize: 10,
                                fontFamily: "Inria Sans"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: Resources.primaryLineColor, width: 1)),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    updateReminder();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size.square(30),
                    padding: const EdgeInsets.all(0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: widget.remStatus == "0"
                      ? Icon(Icons.notification_add_outlined,
                          color: Resources.primaryLineColor)
                      : Icon(Icons.notifications_active_outlined,
                          color: Resources.primaryLineColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
