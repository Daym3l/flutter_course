import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course/models/auth.dart';
import 'package:flutter_course/scoped-models/main.dart';
import 'package:flutter_course/widgets/dialog/widget.dialog.dart';
import 'package:flutter_course/widgets/iu_elements/widget.spiner.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passworldTextController =
      TextEditingController();

  AuthMode _authMode = AuthMode.Login;

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

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (value != _passworldTextController.text) {
          return 'Password do not match.';
        }
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passworldTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();

    final Map<String, dynamic> success = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    if (success['success'] == true) {
      //Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog('An Error Occurred!', success['message']);
          });
    }
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _authMode == AuthMode.Signup
                      ? _buildPasswordConfirmTextField()
                      : Container(),
                  _buildAcceptSwitch(),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _authMode = _authMode == AuthMode.Login
                              ? AuthMode.Signup
                              : AuthMode.Login;
                        });
                      },
                      child: Text(
                          'Switch to ${_authMode == AuthMode.Login ? 'Sign up' : 'Login'}')),
                  SizedBox(
                    height: 10.0,
                  ),
                  ScopedModelDescendant(builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return model.getLoading
                        ? Spiner('authenticating user...')
                        : RaisedButton(
                            textColor: Colors.white,
                            child: Text(
                                '${_authMode == AuthMode.Signup ? 'Sign up' : 'Login'}'),
                            onPressed: () => _submitForm(model.authenticate),
                          );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
