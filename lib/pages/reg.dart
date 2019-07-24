import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';

class RegPage extends StatefulWidget {
  static String tag = 'reg-page';

  RegPage({this.auth});

  final BaseAuth auth;

  @override
  _RegPageState createState() => new _RegPageState();
}

class _RegPageState extends State<RegPage> {
  final _formKey = new GlobalKey<FormState>();

  TextEditingController _fname;
  TextEditingController _lname;
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _username;
  TextEditingController _phone;
  String _errorMessage;

  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
    _fname = TextEditingController(text: "");
    _lname = TextEditingController(text: "");
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _username = TextEditingController(text: "");
    _phone = TextEditingController(text: "");
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    _isLoading = false;
    return false;
  }

  // Perform signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userid = "";
      try {
        Map _profile = {
          'fname': _fname.text,
          'lname': _lname.text,
          'email': _email.text,
          'username': _username.text,
          'phone': _phone.text,
          'password': _password.text,
        };
        userid = await widget.auth.signUp(_profile);
        widget.auth.sendEmailVerification();
        _showVerifyEmailSentDialog();
        print('Signed up user: $userid');
        setState(() {
          _isLoading = false;
        });
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

  Widget _showFirstName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _fname,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'First Name',
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
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Name can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showLastName() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _lname,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Last Name',
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
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Name can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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
            errorStyle: TextStyle(
              color: Colors.blue[900],
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white70)),
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

  Widget _showUsername() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _username,
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'User Name',
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
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'User Name can\'t be empty';
          }
          return null;
        },
      ),
    );
  }

  Widget _showPhone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        controller: _phone,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Phone Number',
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
          if (value.isEmpty) {
            setState(() {
              _isLoading = false;
            });
            return 'Phone number can\'t be empty';
          } else if (value.length != 10)
            return 'Mobile Number must be of 10 digit';
          return null;
        },
      ),
    );
  }

  Widget _showSignupButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _validateAndSubmit,
        padding: EdgeInsets.all(12),
        color: Colors.white,
        child:
            Text('Sign Up', style: TextStyle(color: const Color(0xFFf96327))),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
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
                  SizedBox(height: 50.0),
                  _showLogo(),
                  _showFirstName(),
                  _showLastName(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showUsername(),
                  _showPhone(),
                  SizedBox(height: 50.0),
                  _showSignupButton(),
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
    _fname.dispose();
    _lname.dispose();
    _email.dispose();
    _password.dispose();
    _username.dispose();
    _phone.dispose();
    super.dispose();
  }
}
