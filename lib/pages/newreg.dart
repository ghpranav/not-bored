import 'package:flutter/material.dart';
import 'package:not_bored/widgets/bezierContainer.dart';
//import 'package:google_fonts/google_fonts.dart';
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
  //TextEditingController _repassword;
  TextEditingController _phone;
  String _errorMessage;
  String userid;
  bool _isLoading;
  bool passwordHidden;
  bool repasswordHidden;

  @override
  void initState() {
    super.initState();
    passwordHidden = true;
    repasswordHidden = true;
    _errorMessage = "";
    _isLoading = false;
    _fname = TextEditingController(text: "");
    _lname = TextEditingController(text: "");
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
    _phone = TextEditingController(text: "");
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      barrierDismissible: false,
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
      try {
        Map _profile = {
          'fname': _fname.text,
          'lname': _lname.text,
          'email': _email.text,
          'phone': _phone.text,
          'password': _password.text,
        };
        userid = await widget.auth.signUp(_profile);
        widget.auth.sendEmailVerification();
        _showVerifyEmailSentDialog();
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    }
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

  Widget _entryFname(String title) {
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
            controller: _fname,
            obscureText: false,
            decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value.isEmpty) {
                setState(() {
                  _isLoading = false;
                });
                return 'Name can\'t be empty';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _entryLname(String title) {
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
            controller: _lname,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: false,
            decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value.isEmpty) {
                setState(() {
                  _isLoading = false;
                });
                return 'Name can\'t be empty';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget _entryemail(String title) {
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
            controller: _email,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: false,
            decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
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

  Widget _entrypass(String title) {
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
            controller: _password,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: passwordHidden,
            decoration: InputDecoration(
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
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
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

  /* Widget _reentrypass(String title) {
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
            controller: _repassword,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: repasswordHidden,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    repasswordHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      repasswordHidden = !repasswordHidden;
                    });
                  },
                ),
                errorStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (value) {
              if (value != _password.text) {
                return 'Password is not matching';
              }

              return null;
            },
          )
        ],
      ),
    );
  } */

  Widget _entryphn(String title) {
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
            controller: _phone,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: false,
            decoration: InputDecoration(
                errorStyle: TextStyle(
                  color: Colors.black,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
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
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();

              //Navigator.push(context,
              //MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
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

  /* Widget _title() {
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
  } */
  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.blueAccent));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFname("First Name"),
        _entryLname("Last Name"),
        _entryemail("Email id"),
        _entrypass("Password"),
        //_reentrypass("Retype Password"),
        _entryphn("Phone Number"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: new Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: SizedBox(),
                  ),
                  //_title(),
                  SizedBox(
                    height: 50,
                  ),
                  _emailPasswordWidget(),
                  SizedBox(
                    height: 0,
                  ),
                  _submitButton(),
                  _showErrorMessage(),
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _loginAccountLabel(),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
          Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          _showCircularProgress()
        ],
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
