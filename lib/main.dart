import 'package:flutter/material.dart';

//PAGES
import 'homepage.dart';
import 'login_page.dart';
import 'package:not_bored/reg_page.dart';
import 'searchbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    MyHomePage.tag: (context) => MyStatefulWidget(),
    RegPage.tag: (context) => RegPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: routes,
    );
  }
}

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
