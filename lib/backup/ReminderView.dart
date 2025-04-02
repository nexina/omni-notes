import 'package:flutter/material.dart';
import 'package:omni_notes/view/main.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyWidget'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack.
            // App.navigatorKey.currentState?.pop();
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
