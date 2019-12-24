import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fluster/fluster.dart';
import 'package:not_bored/helpers/map_helper.dart';
import 'package:not_bored/helpers/map_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:not_bored/pages/splash.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:not_bored/services/auth.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  HomePage({Key key, this.auth, this.userId, this.onSignedOut,this.user})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String user;

  @override
  _HomePageState createState() => _HomePageState();
}

const PrimaryColor = const Color(0xFFf96327);
var currentLocation = LocationData;
var location = new Location();

class _HomePageState extends State<HomePage> {
  Set<Marker> markers;

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

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Url image used on normal markers
  final String _markerImageUrl =
      'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwiN-KqS0MvmAhWGyzgGHSBEA1EQjRx6BAgBEAQ&url=https%3A%2F%2Fwww.iconfinder.com%2Ficons%2F2793715%2Fhuman_location_maps_person_user_icon&psig=AOvVaw2WermWw4QZ3xuGP3bwKZqU&ust=1577185543634595';

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  final List<LatLng> _markerLocations = [
    LatLng(41.147125, -8.611249),
    LatLng(41.145599, -8.610691),
    LatLng(41.145645, -8.614761),
    LatLng(41.146775, -8.614913),
    LatLng(41.146982, -8.615682),
    LatLng(41.140558, -8.611530),
    LatLng(41.138393, -8.608642),
    LatLng(41.137860, -8.609211),
    LatLng(41.138344, -8.611236),
    LatLng(41.139813, -8.609381),
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    updateLocation();
    _initMarkers();
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

  Future<void> updateLocation() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentReference _ref =
        Firestore.instance.collection('users').document(user.uid);
    Geoflutterfire geo = Geoflutterfire();
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);

    return _ref.updateData(<String, dynamic>{
      'position': point.data,
    });
  }

  void _initMarkers() async {
    final List<MapMarker> markers = [];

    for (LatLng markerLocation in _markerLocations) {
      final BitmapDescriptor markerImage =
          await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

      markers.add(
        MapMarker(
          id: _markerLocations.indexOf(markerLocation).toString(),
          position: markerLocation,
          icon: markerImage,
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
    stream: Firestore.instance.collectionGroup(widget.user).snapshots(),
    builder: (BuildContext context, AsyncSnapshot snapshot1) {
       if (snapshot1.connectionState == ConnectionState.waiting) {
            return new Splash();
          }
      
    return Scaffold(
      body: _initialPosition == null
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
            onPressed: () {},
          ),
        ),
      ),
    );
    },
    );
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
        markers: _markers,
        onCameraMove: (position) => _updateMarkers(position.zoom),
      ),
    );
  }
}
