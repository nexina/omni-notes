import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:omni_notes/resources.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool isPickerOpen = false;
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
            decoration:
                BoxDecoration(color: const Color(0x00242424).withOpacity(0.5)),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    //width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                //Resources.primaryLineColor = Colors.red;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              color: Resources.primaryLineColor,
                              size: 10,
                            ),
                          ),
                          Center(
                            child: Text(
                              "Omni Notes",
                              style: TextStyle(
                                  color: Resources.primaryTextColor,
                                  fontFamily: "Inria Sans",
                                  fontSize: 30),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Resources.fetchData("project_omni");
                              },
                              child: Text(
                                "A project of Project Omni",
                                style: TextStyle(
                                    color: Resources.tertiaryTextColor,
                                    fontFamily: "Inria Sans",
                                    fontSize: 10),
                              ),
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Resources.fetchData("personal_website");
                              },
                              child: Text(
                                "Made by Rakibul Hasan",
                                style: TextStyle(
                                    color: Resources.tertiaryTextColor,
                                    fontFamily: "Inria Sans",
                                    fontSize: 10),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Resources.primaryBackgroundColor),
                      child: ListView(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Resources.secondaryLineColor,
                                        width: 1))),
                            child: TextButton(
                              onPressed: () async {
                                if (!isPickerOpen) {
                                  isPickerOpen = true;
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['jpg', 'png', 'jpeg'],
                                  );

                                  if (result != null) {
                                    File file = File(result.files.single.path!);
                                    setState(() {
                                      Resources.BackgroundImage = file.path;
                                    });
                                  } else {
                                    // User canceled the picker
                                  }
                                }
                              },
                              child: Text(
                                "Background Image",
                                style: TextStyle(
                                    color: Resources.primaryTextColor,
                                    fontFamily: "Inria Sans"),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Resources.secondaryLineColor,
                                        width: 1))),
                            child: TextButton(
                              onPressed: () async {
                                Resources.ClearPreferences();
                              },
                              child: const Text(
                                "Clear Preferences",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 137, 129),
                                    fontFamily: "Inria Sans"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
