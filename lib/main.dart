import 'package:flutter/material.dart';
import 'package:omni_notes/android.dart';
import 'package:omni_notes/desktop.dart';
import 'package:omni_notes/notification_service.dart';
import 'package:omni_notes/resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initilizeNotification();
  runApp(const app());
}

class app extends StatelessWidget {
  const app({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    if (Resources.isMobile(context)) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const AndroidMain(),
      );
    } else {
      return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const DesktopMain(),
      );
    }
  }
}
