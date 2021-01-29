import 'package:flutter/material.dart';
import 'package:flutter_course/pages/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurpleAccent),
        home: AuthPage());
  }
}
