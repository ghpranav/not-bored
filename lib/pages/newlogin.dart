import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:not_bored/widgets/bezierContainer.dart';

import 'package:not_bored/services/auth.dart';

import 'package:not_bored/pages/newreg.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  LoginPage({this.auth, this.onsignedIn});

  final BaseAuth auth;
  final VoidCallback onsignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _email;
  TextEditingController _password;
  String _errorMessage;

  bool _isLoading;
  bool passwordHidden;

  @override
  void initState() {
    super.initState();
    passwordHidden = true;
    _errorMessage = "";
    _isLoading = false;

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
          widget.onsignedIn();
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

  void _forgotPassword() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (_email.text == "") {
      setState(() {
        _isLoading = false;
        _errorMessage = "Please enter an Email address";
      });
    } else {
      try {
        await widget.auth.resetPassword(_email.text);
        setState(() {
          _isLoading = false;
        });
        _showforgotpassEmailSentDialog();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
  }

  void _showforgotpassEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Reset your password"),
          content: new Text(
              "Link to reset your password has been sent to your email Id"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _enterpass(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            controller: _password,
            obscureText: passwordHidden,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    passwordHidden = !passwordHidden;
                  });
                },
              ),
              errorStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                setState(() {
                  _isLoading = false;
                });
                return 'Password can\'t be empty';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _enteremail(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            style: TextStyle(
              color: Colors.black,
            ),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            obscureText: false,
            decoration: InputDecoration(
              errorStyle: TextStyle(
                color: Colors.black,
              ),
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
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
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: _validateAndSubmit,
        padding: EdgeInsets.all(12),
        color: Color(0xFFf96327),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  /* Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  } */

  /* Widget _googleButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('G',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Text('Log in with Google',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  } */

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          RegPage(auth: widget.auth)));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Color(0xFFf96327),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
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

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'N',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFFf96327),
          ),
          children: [
            TextSpan(
              text: 'ot',
              style: TextStyle(color: Color(0xFFf96327), fontSize: 30),
            ),
            TextSpan(
              text: ' B',
              style: TextStyle(color: Color(0xFFf96327), fontSize: 30),
            ),
            TextSpan(
              text: 'ored',
              style: TextStyle(color: Color(0xFFf96327), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _enteremail("Email id"),
        _enterpass("Password"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: new Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: SizedBox(),
                  ),
                  _title(),
                  SizedBox(
                    height: 50,
                  ),
                  _emailPasswordWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: _forgotPassword,
                      padding: EdgeInsets.all(12),
                      color: Colors.white,
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  _submitButton(),
                  //_divider(),
                  // _showCircularProgress(),
                  // _googleButton(),
                  _showErrorMessage(),
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _createAccountLabel(),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
            Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer())
          ],
        ),
      ),
    )));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
