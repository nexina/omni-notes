import 'package:flutter/material.dart';
import 'package:omni_notes/view_controller/mainwindow_vc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: MainWindowViewController());
  }
}
