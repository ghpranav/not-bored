import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:not_bored/pages/splash.dart';
import 'package:not_bored/pages/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:not_bored/services/auth.dart';
import 'package:not_bored/services/serve.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  HomePage({Key key, this.auth, this.userId, this.onSignedOut, this.user})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String user;

  @override
  _HomePageState createState() => _HomePageState();
}

const PrimaryColor = const Color(0xFFf96327);

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;

  static LatLng _initialPosition;

  Location _locationService = new Location();

  String error;

  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();

  GoogleMap googleMap;
  Map<MarkerId, Marker> markers = new Map<MarkerId, Marker>();
  List<Marker> markerTest = [];

  /// Set of displayed markers and cluster markers on the map
  BitmapDescriptor myIcon;
  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(0, 0)), 'lib/assests/person.jpg')
        .then((onValue) {
      myIcon = onValue;
    });
    createMarkers();
    updateLocation();
  }

  initialLocation() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);
    geo.Position position = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  createMarkers() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection(user.uid)
        .getDocuments();

    var frndList = querySnapshot.documents;
    if (frndList.length == 1) initialLocation();
    frndList.forEach((docs) {
      var frndId = docs['userid'];
      if (frndId != null) {
        var frndListData =
            Firestore.instance.collection("users").document(frndId).snapshots();
        frndListData.forEach((docs1) {
          if (docs1.data != null)
            initMarker(docs1.data, docs1.documentID, frndList.length - 1);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_initialPosition == null)
          ? Splash()
          : Container(
              child: Stack(
                children: <Widget>[
                  _googlemap(context),
                ],
              ),
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
            onPressed: () async {
              await sendNBmsg();
              var connectedTo = await waitNBmsg();
              if (connectedTo != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Chat(
                              user: widget.userId,
                              friend: connectedTo.toString(),
                            )));
              }
            },
          ),
        ),
      ),
    );
  }

  void initMarker(lugar, lugaresid, length) {
    var markerIdVal = lugaresid;

    final MarkerId markerId = MarkerId(markerIdVal);
    var g = lugar['position']['geopoint'] as GeoPoint;
    print(g.latitude);
    print(g.longitude);
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(g.latitude, g.longitude),
      icon: BitmapDescriptor.defaultMarker,
      visible: true,
      flat: true,
    );

    // adding a new marker to map

    markerTest.add(marker);
    if (markerTest.length == length) initialLocation();

    print(markerTest);
  }

  Widget _googlemap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        zoomGesturesEnabled: true,
        mapType: MapType.normal,
        myLocationEnabled: true,
        scrollGesturesEnabled: true,
        mapToolbarEnabled: true,
        initialCameraPosition:
            CameraPosition(target: _initialPosition, zoom: 16),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markerTest),
      ),
    );
  }
}
