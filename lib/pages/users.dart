import 'package:flutter/material.dart';
import 'package:not_bored/pages/searchbar.dart';

class Users extends StatefulWidget {
  Users({Key key,  this.data}) : super(key: key);

  
  final Map data;
  @override
  _UsersState createState() => _UsersState();
}
const PrimaryColor = const Color(0xFFf96327);
class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    
       
           return new Scaffold(
            appBar: AppBar(
                backgroundColor: PrimaryColor,
                automaticallyImplyLeading: true,
                title: Text('Profile Page'),
     ),
     body: Text(widget.data['name']),
      );
      
  }
}
