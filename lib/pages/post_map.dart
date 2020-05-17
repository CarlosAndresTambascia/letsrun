import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'maps.dart';

class PostMap extends StatefulWidget {
  static String id = 'postMap';
  static String startingPositionMsg = 'Principio del recorrido';
  static String finalPositionMsg = 'Final del recorrido';
  final double latitudeStarting;
  final double longitudeStarting;
  final double latitudeEnd;
  final double longitudeEnd;

  PostMap(this.latitudeStarting, this.longitudeStarting, this.latitudeEnd, this.longitudeEnd);

  @override
  _PostMapState createState() => _PostMapState(
      latitudeStarting: latitudeStarting,
      longitudeStarting: longitudeStarting,
      latitudeEnd: latitudeEnd,
      longitudeEnd: longitudeEnd);
}

class _PostMapState extends State<PostMap> {
  double latitude;
  double longitude;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _googleMapController;
  static LatLng _center;
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  bool _loading = false;
  double latitudeStarting;
  double longitudeStarting;
  double latitudeEnd;
  double longitudeEnd;

  _PostMapState({this.latitudeStarting, this.longitudeStarting, this.latitudeEnd, this.longitudeEnd});

  @override
  void initState() {
    super.initState();
    var startingPlace = LatLng(latitudeStarting, longitudeStarting);
    var endingPlace = LatLng(latitudeEnd, longitudeEnd);
    _center = startingPlace;
    _setMarkers(startingPlace, endingPlace);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Theme.of(context).primaryColor,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Esta es la ruta'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(target: _center, zoom: 13.0),
                mapType: _currentMapType,
                markers: _markers,
                //onTap: _handleTap,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      button(_getCurrentLocation, Icons.my_location, 'myLocaiton'),
                      SizedBox(height: 16.0),
                      button(() => Navigator.pop(context), Icons.check_circle, 'done'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      inAsyncCall: _loading,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    _controller.complete(controller);
  }

  Widget button(Function function, IconData icon, String heroTag) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(icon, size: 36.0),
      heroTag: heroTag,
    );
  }

  _setMarkers(LatLng startingPoint, LatLng endingPoint) {
    Marker startingMarker = Marker(
      markerId: MarkerId(Maps.startingPositionMsg),
      position: startingPoint,
      infoWindow: InfoWindow(
        title: Maps.startingPositionMsg,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    Marker finalMarker = Marker(
      markerId: MarkerId(Maps.finalPositionMsg),
      position: endingPoint,
      infoWindow: InfoWindow(
        title: Maps.finalPositionMsg,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    setState(() => _markers.add(startingMarker));
    setState(() => _markers.add(finalMarker));
  }

  _getCurrentLocation() async {
    setState(() => _loading = true);
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.add(
          Marker(position: _center, infoWindow: InfoWindow(title: 'Tu ubicacion'), markerId: MarkerId('myLocaiton')));
      _loading = false;
      _googleMapController.moveCamera(CameraUpdate.newLatLng(_center));
    });
  }
}
