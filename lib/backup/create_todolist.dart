import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateToDoList extends StatefulWidget {
  final VoidCallback onDone;
  final Function(String, String) onTaskNameChanged;
  const CreateToDoList(
      {super.key, required this.onDone, required this.onTaskNameChanged});

  @override
  State<CreateToDoList> createState() => _CreateToDoListState();
}

class _CreateToDoListState extends State<CreateToDoList> {
  @override
  Widget build(BuildContext context) {
    String taskName = "New Task";
    TextEditingController taskNameController = TextEditingController();
    // DateTime selectedDateTime = DateTime.now();
    DateTime selectedDateTime = DateTime.now().toLocal();
    String dateText =
        DateFormat('dd MMM yyyy').format(selectedDateTime).toString();
    String timeText =
        DateFormat('hh : mm a').format(selectedDateTime).toString();
    "${(selectedDateTime.hour > 12 ? selectedDateTime.hour - 12 : selectedDateTime.hour).toString()} : ${selectedDateTime.minute} ${selectedDateTime.hour > 12 ? "PM" : "AM"}";
    return AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(132, 26, 26, 26),
            borderRadius: BorderRadius.circular(15),
            border: const Border(
              top: BorderSide(color: Colors.white, width: 2),
              bottom: BorderSide(color: Colors.white, width: 2),
            ),
          ),
          child: Column(children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: taskNameController,
                textAlign: TextAlign.center,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'New Task',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(150, 173, 173, 173),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                  fontSize: 12.0,
                  fontFamily: "Inria Sans",
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Date: ",
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                          fontSize: 15.0,
                          fontFamily: "Inria Sans",
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 10),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                selectedDateTime = DateTime(selectedDate.year,
                                    selectedDate.month, selectedDate.day);
                                setState(() {
                                  dateText = DateFormat('dd / MMM / yyyy')
                                      .format(selectedDate);

                                  print(selectedDateTime.toString());
                                });
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Builder(
                            builder: (context) {
                              return Text(
                                dateText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  backgroundColor: Colors.transparent,
                                  fontSize: 10.0,
                                  fontFamily: "Inria Sans",
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Time: ",
                        style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                          fontSize: 15.0,
                          fontFamily: "Inria Sans",
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((selectedTime) {
                              selectedDateTime = DateTime(
                                  selectedTime!.hour, selectedTime.minute);
                              setState(() {
                                timeText =
                                    "${(selectedTime.hour > 12 ? selectedTime.hour - 12 : selectedTime.hour).toString()} : ${selectedTime.minute} ${selectedTime.hour > 12 ? "PM" : "AM"}";
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Builder(builder: (context) {
                            return Text(
                              timeText,
                              style: const TextStyle(
                                color: Colors.white,
                                backgroundColor: Colors.transparent,
                                fontSize: 10.0,
                                fontFamily: "Inria Sans",
                              ),
                            );
                          })),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        if (taskNameController.text != "") {
                          taskName = taskNameController.text;
                        } else {
                          taskName = "New Task";
                        }
                        widget.onTaskNameChanged(
                            taskName, "$dateText, $timeText");
                      });
                      widget.onDone();
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.transparent,
                        fontSize: 15.0,
                        fontFamily: "Inria Sans",
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.transparent,
                        fontSize: 15.0,
                        fontFamily: "Inria Sans",
                      ),
                    )),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
