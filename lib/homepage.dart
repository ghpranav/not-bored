import 'package:flutter/material.dart';

//PAGES
import 'about.dart';
import 'info.dart';
import 'searchbar.dart';
import 'auth.dart';

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    ),
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Friends',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      showSearch(context: context, delegate: DataSearch());
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavigationBar2 = BottomNavigationBar(
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
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: bottomNavigationBar2,
    );
  }
}

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
  int _selectedIndex=0;

    void _onItemTapped(int index) {
    if (index == 1) {
      showSearch(context: context, delegate: DataSearch());
    }
    else if(index == 2){
    

    }
    else {
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
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
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
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,),
    );
  }
}


