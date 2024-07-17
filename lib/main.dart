// Import the necessary Flutter material design library
import 'package:flutter/material.dart';

// Import our custom PongGame widget from the pong_game.dart file
import 'pong_game.dart';

// The main function is the entry point for all our Flutter apps
void main() {
  // runApp is a built-in Flutter function that inflates the given widget
  // and attaches it to the screen
  runApp(const MyApp());
}

// MyApp is a StatelessWidget. This means it is immutable and can't change its state.
// It's the root widget of your application.
class MyApp extends StatelessWidget {
  // This constructor allows us to pass a Key to this widget if needed.
  // The 'key' parameter is used in advanced scenarios for preserving state.
  // The 'const' keyword here is used for compile-time constants.
  const MyApp({super.key});

  // The build method is called by the Flutter framework to build this widget.
  // It describes the part of the user interface represented by this widget.
  @override
  Widget build(BuildContext context) {
    // MaterialApp is a convenience widget that wraps a number of widgets that are
    // commonly required for material design applications.
    return MaterialApp(
      // The title of the app, which is used by the device to identify the app
      // in the task manager or when the app is minimized.
      title: 'Flutter Pong',
      
      // ThemeData defines the visual properties for the entire app, such as colors and text styles.
      theme: ThemeData(
        // This is the color used for major parts of the app (like the app bar).
        primarySwatch: Colors.blue,
        // This sets the overall brightness of the app. Brightness.dark means a dark theme.
        brightness: Brightness.dark,
      ),
      
      // The home property specifies the widget that will be displayed when the app is launched.
      // In this case, it's our custom PongGame widget.
      home: const PongGame(),
    );
  }
}