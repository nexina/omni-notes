import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Resources {
  static String defaultBackgroundImage = "images/default.jpg";
  static String backgroundImage = "images/default.jpg";
  static String keyNotesList = "notesList";
  static String keyTodoList = "todoList";
  static String keyReminderList = "remList";

  static Color primaryLineColor = Colors.white; // Colors.white;
  static Color secondaryLineColor = const Color.fromARGB(
      157, 255, 255, 255); // const Color.fromARGB(157, 255, 255, 255);
  static Color primaryTextColor = Colors.white; // Colors.white;
  static Color secondaryTextColor = const Color.fromARGB(
      157, 255, 255, 255); // const Color.fromARGB(157, 255, 255, 255);
  static Color tertiaryTextColor = const Color.fromARGB(112, 255, 255, 255);
  static Color invertPrimaryTextColor =
      const Color.fromARGB(255, 0, 0, 0); // Colors.white;
  static Color invertSecondaryTextColor = const Color.fromARGB(
      157, 0, 0, 0); // const Color.fromARGB(157, 255, 255, 255);
  static Color invertTertiaryTextColor = const Color.fromARGB(111, 0, 0, 0);

  static Color primaryBackgroundColor =
      const Color.fromARGB(255, 47, 47, 47); // Colors.white;
  static Color secondaryBackgroundColor = const Color.fromARGB(
      157, 59, 59, 59); // const Color.fromARGB(157, 255, 255, 255);

  ImageProvider getImageProvider(String path) {
    if (path.startsWith('images/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  static bool isMobile(double width) {
    return Platform.isAndroid || Platform.isIOS || width < 600;
  }

  static void clearPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });

    backgroundImage = defaultBackgroundImage;
  }

  static void fetchData(String x) async {
    final response = await http.get(Uri.parse(
        'https://rakibul-portfolio-e0a03-default-rtdb.firebaseio.com/url.json'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String projectOmniUrl = data[x];
      launchUrl(Uri.parse(projectOmniUrl));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
