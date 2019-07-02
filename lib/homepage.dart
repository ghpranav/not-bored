import 'package:flutter/material.dart';
import 'package:not_bored/my_friends.dart';

//PAGES
import 'about.dart';
import 'info.dart';
import 'searchbar.dart';
import 'auth.dart';
import 'my_friends.dart';

class MyHomePage extends StatefulWidget {
  static String tag = 'home-page';
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  _signOutClose() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pop();
  }

  int _selectedIndex = 0;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resend link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: _signOutClose,
            ),
          ],
        );
      },
    );
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
              onPressed: _signOutClose,
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      showSearch(context: context, delegate: DataSearch());
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MyFriendsPage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf96327),
        title: Text("Not Bored"),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          backgroundColor: const Color(0xFFf96327),
        ),
        child: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('Adithya'),
                accountEmail: Text('adithyaaravi10@gmail.com'),
                decoration: BoxDecoration(color: const Color(0xFFf96327)),
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UserInfo()));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://yt3.ggpht.com/-hvABjgr3fn8/AAAAAAAAAAI/AAAAAAAAFLI/0LG1v5zQMKw/s88-mo-c-c0xffffffff-rj-k-no/photo.jpg'),
                  ),
                ),
                onDetailsPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => UserInfo()));
                },
              ),
              ListTile(
                title: Text('About'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => AboutPage()));
                },
              ),
              ListTile(
                title: Text('Log Out'),
                onTap: _signOut,
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RawMaterialButton(
        onPressed: () {},
        child: new Icon(
          Icons.sentiment_dissatisfied,
          size: 140.0,
          color: Colors.white54,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: const Color(0xFFf96327),
        padding: const EdgeInsets.all(15.0),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Friends'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFf96327),
        onTap: _onItemTapped,
      ),
    );
  }
}
