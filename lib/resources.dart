import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Resources {
  static String Default_BackgroundImage = "images/default.jpg";
  static String BackgroundImage = "images/default.jpg";
  static String KEY_NOTESLIST = "notesList";
  static String KEY_TODOLIST = "todoList";
  static String KEY_REMINDERLIST = "remList";

  static Color primaryLineColor = Colors.white; // Colors.white;
  static Color secondaryLineColor = const Color.fromARGB(
      157, 255, 255, 255); // const Color.fromARGB(157, 255, 255, 255);
  static Color primaryTextColor = Colors.white; // Colors.white;
  static Color secondaryTextColor = const Color.fromARGB(
      157, 255, 255, 255); // const Color.fromARGB(157, 255, 255, 255);
  static Color tertiaryTextColor = const Color.fromARGB(112, 255, 255, 255);
  static Color invertPrimaryTextColor =
      const Color.fromARGB(255, 0, 0, 0); // Colors.white;
  static Color invertSecondaryTextColor =
      Color.fromARGB(157, 0, 0, 0); // const Color.fromARGB(157, 255, 255, 255);
  static Color invertTertiaryTextColor = Color.fromARGB(111, 0, 0, 0);

  static Color primaryBackgroundColor =
      Color.fromARGB(255, 47, 47, 47); // Colors.white;
  static Color secondaryBackgroundColor = Color.fromARGB(
      157, 59, 59, 59); // const Color.fromARGB(157, 255, 255, 255);

  ImageProvider getImageProvider(String path) {
    if (path.startsWith('images/')) {
      return AssetImage(path);
    } else {
      return FileImage(File(path));
    }
  }

  static bool isMobile(BuildContext context) {
    return Platform.isAndroid ||
        Platform.isIOS ||
        MediaQuery.of(context).size.width < 600;
  }

  static void ClearPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });

    BackgroundImage = Default_BackgroundImage;
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



// class CustomIcons {
//   static const IconData myIcon = IconData(0xe800, fontFamily: 'CustomIcons');
// }

// // Then, to use it:
// Icon(CustomIcons.myIcon)