import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:not_bored/models/user_provider.dart';

//PAGES
import 'package:not_bored/pages/login.dart';
import 'package:not_bored/pages/reg.dart';
import 'package:not_bored/pages/about.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/searchbar.dart';
import 'package:not_bored/pages/my_friends.dart';
import 'package:not_bored/pages/splash.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => UserProvider.instance(),
      child: Consumer(
        builder: (context, UserProvider user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Unauthenticated:
            case Status.Authenticating:
              return LoginPage();
            case Status.Regeistering:
              return RegPage();
            case Status.Authenticated:
              return LandingPage(user: user.user);
            default:
              return Splash();
          }
        },
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  static String tag = 'landing-page';
  final FirebaseUser user;

  const LandingPage({Key key, this.user}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = widget.user.isEmailVerified;
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.user.sendEmailVerification();
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
              onPressed: () => Provider.of<UserProvider>(context).signOut(),
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
              onPressed: () => Provider.of<UserProvider>(context).signOut(),
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyFriendsPage()));
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
                            builder: (BuildContext context) => MyInfo()));
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
                          builder: (BuildContext context) => MyInfo()));
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
                onTap: () => Provider.of<UserProvider>(context).signOut(),
              )
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 140.0,
        width: 140.0,
        child: FittedBox(
          child: FloatingActionButton(
            child: new Icon(
              Icons.sentiment_dissatisfied,
              size: 50.0,
              color: Colors.white54,
            ),
            backgroundColor: const Color(0xFFf96327),
            foregroundColor: Colors.white54,
            onPressed: () {},
          ),
        ),
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
