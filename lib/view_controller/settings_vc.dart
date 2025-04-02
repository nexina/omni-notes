import 'package:flutter/material.dart';
import 'package:omni_notes/view/settings/settings.dart';

import 'dart:async';
import 'package:flutter/services.dart';

class SettingsViewController extends StatefulWidget {
  const SettingsViewController({super.key});

  @override
  State<SettingsViewController> createState() => _SettingsViewControllerState();
}

class _SettingsViewControllerState extends State<SettingsViewController> {
  bool isPickerOpen = false;

  void setIsPickerOpen(bool isPickerOpen) {
    setState(() {
      isPickerOpen = isPickerOpen;
    });
  }

  bool getIsPickerOpen() {
    return isPickerOpen;
  }

  static const platform = MethodChannel('nexina.omni.notes/reminder');
// Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final result = await platform.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _setScheduledReminder(
      String title, String content, int time, int nid, String cid) async {
    final result = await platform.invokeMethod<dynamic>(
      'setReminder',
      {
        'title': title,
        'content': content,
        'time': time,
        'nid': nid,
        'cid': cid,
      },
    );
    print("Reminder Set Successfully: $result");
  }

  @override
  Widget build(BuildContext context) {
    return SettingsView(
      setIsPickerOpen: setIsPickerOpen,
      getIsPickerOpen: getIsPickerOpen,
      setScheduledReminder: _setScheduledReminder,
    );
  }
}
