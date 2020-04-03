import 'package:flutter/material.dart';
import 'package:not_bored/pages/privacyPolicy.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override

 Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              "You ain't bored anymore",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
      
          ],
        ));
  }


Widget _privacyPolicy() {
    return InkWell(
      child: Text(
        'User Agreement and Privacy Policy',
        style: TextStyle(color: Colors.black ),
      ),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PrivacyPolicy())),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('About'),),
        body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFf96327), Color(0xFFf96327)])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
               _privacyPolicy(),
            ]
          ),
        ),
        ),
    );
  }
}
