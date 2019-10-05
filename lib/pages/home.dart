import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:not_bored/services/auth.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  HomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}
const PrimaryColor = const Color(0xFFf96327);
class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController>_controller=Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _googlemap(context)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 180.0,
        width: 140.0,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: 'MainBtn',
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
    );
  }
Widget _googlemap(BuildContext context)
{
  return Container(
    height:MediaQuery.of(context).size.height, 
    width:MediaQuery.of(context).size.width,
    child: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(12.932476, 77.535566),zoom: 12),
      onMapCreated: (GoogleMapController controller){
        _controller.complete(controller);
      },
      markers: {
        me,
        },
    ),
    );
}
}
Marker me=Marker(
  markerId: MarkerId('me'),
  position: LatLng(12.932476, 77.535566),
  infoWindow: InfoWindow(title: 'Me'),
  icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
  );
