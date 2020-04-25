import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:not_bored/pages/fab.dart';
import 'package:not_bored/pages/splash.dart';
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
var isLoadingFAB = false;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GoogleMapController mapController;

  static LatLng _initialPosition;

  Location _locationService = new Location();

  String error;
  String _darkmapStyle;
  String _stndrdmapStyle;

  bool currentWidget = true;

  Completer<GoogleMapController> _controller = Completer();

  GoogleMap googleMap;
  Map<String, GeoPoint> nbLocList = new Map<String, GeoPoint>();
  geo.Position position;
  Map<MarkerId, Marker> markers = new Map<MarkerId, Marker>();
  List<Marker> markerTest = [];

  /// Set of displayed markers and cluster markers on the map
  BitmapDescriptor myIcon;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('lib/assests/mapdark.txt').then((string) {
      _darkmapStyle = string;
    });
    rootBundle.loadString('lib/assests/mapstndrd.txt').then((string) {
      _stndrdmapStyle = string;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(0.5, 0.5)), 'images/person.png')
        .then((onValue) {
      myIcon = onValue;
    });

    createMarkers();
    updateLocation();
  }

  initialLocation() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.high, interval: 1000);
    position = await geo.Geolocator()
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
    return _initialPosition == null
        ? Scaffold(body: Splash())
        : Scaffold(
            body: Container(
              child: Stack(
                children: <Widget>[
                  _googlemap(context),
                ],
              ),
            ),

            // floatingActionButton: FancyFab(
            //   onPressed: null,
            //   icon: Icons.ac_unit,
            //   tooltip: 'ok',
            // ),
            floatingActionButton:
                // child: Container(
                //   height: MediaQuery.of(context).size.height /
                //       MediaQuery.of(context).size.width *
                //       100,
                //   width: MediaQuery.of(context).size.height /
                //       MediaQuery.of(context).size.width *
                //       50,
                // color: Colors.green,
                FittedBox(
              child: RadialMenu(),
            ),
            //),

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }

  void initMarker(lugar, lugaresid, length) {
    var markerIdVal = lugaresid;

    final MarkerId markerId = MarkerId(markerIdVal);
    var g = lugar['position']['geopoint'] as GeoPoint;
    nbLocList[lugaresid.toString()] = g;
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(g.latitude, g.longitude),
      icon: myIcon,
      visible: true,
      flat: true,
    );

    // adding a new marker to map

    markerTest.add(marker);
    if (markerTest.length == length) initialLocation();
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
          bool isDark =
              MediaQuery.of(context).platformBrightness == Brightness.dark;
          if (isDark) {
            controller.setMapStyle(_darkmapStyle);
          } else {
            controller.setMapStyle(_stndrdmapStyle);
          }
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(markerTest),
      ),
    );
  }
}

// The stateful widget + animation controller
