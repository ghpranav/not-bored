import 'package:flutter/material.dart';
import 'package:not_bored/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:not_bored/pages/home.dart';
import 'package:not_bored/pages/about.dart';
import 'package:not_bored/pages/info.dart';
import 'package:not_bored/pages/searchbar.dart';
import 'package:not_bored/pages/my_friends.dart';
import 'package:not_bored/pages/splash.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<LandingPageProvider>(context);
    var currentTab = [
      HomePage(),
      DataSearch(),
      //showSearch(context: context, delegate: DataSearch()),
      MyFriendsPage(),
    ];

    return new StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Splash();
          }
          var userDocument = snapshot.data;
          return new Scaffold(
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
                      accountName: Text(userDocument['fname']),
                      accountEmail: Text(userDocument['email']),
                      decoration: BoxDecoration(color: const Color(0xFFf96327)),
                      currentAccountPicture: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MyInfo(
                                        userId: widget.userId,
                                        auth: widget.auth,
                                      )));
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
                                builder: (BuildContext context) => MyInfo(
                                      userId: widget.userId,
                                      auth: widget.auth,
                                    )));
                      },
                    ),
                    ListTile(
                      title: Text('About'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AboutPage()));
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
            body: currentTab[provider.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: provider.currentIndex,
              onTap: (index) {
                provider.currentIndex = index;
              },
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
            ),
          );
        });
  }
}

class LandingPageProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
