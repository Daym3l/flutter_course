import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String _email;
  String _password;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (String value) {
              setState(() {
                _email = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            maxLines: 3,
            onChanged: (String value) {
              setState(() {
                _password = value;
              });
            },
          ),
          SwitchListTile(
              title: Text('Accept Terms'),
              value: _acceptTerms,
              onChanged: (bool value) {
                setState(() {
                  _acceptTerms = value;
                });
              }),
          SizedBox(
            height: 8.0,
          ),
          RaisedButton(
            child: Text('Login'),
            textColor: Colors.white,
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
        ],
      ),
    ));
  }
}
