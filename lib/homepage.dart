import 'package:flutter/material.dart';

//PAGES
import './about.dart';
import './info.dart';
import './searchbar.dart';
// import './searchBar2.dart';
import './rippleEffect.dart';

class MyHomePage extends StatefulWidget {
  static String tag = 'home-page';
  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf96327),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
            alignment: Alignment.centerLeft,
          )
        ],
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
    );
  }
}
