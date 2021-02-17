import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  String email;
  String password;
  bool _acceptTerms = false;

  BoxDecoration _buildBackgroudImage() {
    return BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
        image: AssetImage('assets/images/background.jpg'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroudImage(),
        padding: EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (String value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white),
                  onChanged: (String value) {
                    setState(() {
                      password = value;
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
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
