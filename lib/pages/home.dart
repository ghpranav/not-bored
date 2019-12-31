import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:not_bored/pages/splash.dart';

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

  CameraPosition _currentCameraPosition;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = new Location();
  bool _permission = false;
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
//initialLocation();

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

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);
    geo.Position position = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude), zoom: 16);
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(
                CameraUpdate.newCameraPosition(_currentCameraPosition));
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }
  }

  slowRefresh() async {
    _locationSubscription.cancel();
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.BALANCED, interval: 10000);
    _locationSubscription =
        _locationService.onLocationChanged().listen((LocationData result) {});
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collectionGroup(widget.user).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return new Splash();
        }
        snapshot1.data.documents.forEach((index) {
          if (index.data['userid'] != null) {
            Firestore.instance
                .collection('users')
                .where('userid', isEqualTo: index.data['userid'])
                .getDocuments()
                .then((docs) {
              if (docs.documents.isNotEmpty) {
                for (int i = 0; i < docs.documents.length; i++) {
                  initMarker(docs.documents[i], docs.documents[i].documentID,
                      docs.documents.length);
                }
              }
            });
          }
        });
        return Scaffold(
          body: (_initialPosition == null && markerTest.length == 0)
              ? Splash()
              : Container(
                  child: Stack(
                    children: <Widget>[
                      _googlemap(context),
                    ],
                  ),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
                onPressed: () {
                  sendNBmsg();
                  //_text();
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => Chat(
                  //               user: widget.user,
                  //               friend: "v25Su3BCrWUYZwl7Lp5pqaTk7rv1",
                  //             )));
                },
              ),
            ),
          ),
        );
      },
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
