import 'package:flutter/material.dart';
import 'package:flutter_course/pages/home.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: RaisedButton(
          child: Text('Login'),
          textColor: Colors.white,
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              )),
        ),
      ),
    );
  }
}
