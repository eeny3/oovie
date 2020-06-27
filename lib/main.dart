import 'package:flutter/material.dart';
import 'package:oovieapp/screens/home_screen.dart';
import 'package:oovieapp/screens/loading_screen.dart';
import 'screens/start_screen.dart';
import 'screens/main_screen.dart';

bool showSpinner = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: StartScreen.id,
      routes: {
        StartScreen.id: (context) => StartScreen(),
        LoadingScreen.id: (context) => LoadingScreen(),
        MainScreen.id: (context) => MainScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
