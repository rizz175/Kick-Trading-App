import 'package:flutter/material.dart';
import 'package:kicks_trade/pages/login_page.dart';
import 'package:kicks_trade/pages/signup_page.dart';
import 'package:kicks_trade/services/authentication.dart';
import 'package:kicks_trade/pages/root_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KicksTrade',
      theme: ThemeData(
        // This is the theme of your application.
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => LoginPage(auth: new Auth()),
        '/signup': (context) => SignUpPage(auth: new Auth()),
      },
      home: new RootPage(auth: new Auth()),
    );
  }
}
