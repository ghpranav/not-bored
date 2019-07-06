import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';

import 'package:not_bored/pages/reg.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _email;
  TextEditingController _password;
  String _errorMessage;

  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await widget.auth.signIn(_email.text, _password.text);
        print('Signed in: $userId');
        setState(() {
          _isLoading = false;
        });

        if (userId != null && userId.length > 0) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  Widget _showLogo() {
    return Text('NOT BORED',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          letterSpacing: 3.0,
        ),
        textAlign: TextAlign.center);
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _email,
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            icon: new Icon(
              Icons.mail,
              color: Colors.black,
            )),
        validator: (value) {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Email can\'t be empty';
          } else if (!regex.hasMatch(value)) return 'Enter Valid Email';
          return null;
        },
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _password,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            icon: new Icon(
              Icons.lock,
              color: Colors.black,
            )),
        validator: (value) {
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Password can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showLoginButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _validateAndSubmit,
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child: Text('Log In', style: TextStyle(color: const Color(0xFFf96327))),
      ),
    );
  }

  Widget _showRegButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          //Navigator.of(context).pushNamed(RegPage.tag);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RegPage(auth: widget.auth)));
        },
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child:
            Text('Register', style: TextStyle(color: const Color(0xFFf96327))),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showBody() {
    return new Scaffold(
        backgroundColor: const Color(0xFFf96327),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: new Form(
              key: _formKey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  SizedBox(height: 100.0),
                  _showLogo(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showLoginButton(),
                  _showRegButton(),
                  _showErrorMessage(),
                ],
              ),
            )));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        _showBody(),
        _showCircularProgress(),
      ],
    ));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
