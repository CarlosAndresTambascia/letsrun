import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Maps extends StatefulWidget {
  static const String id = 'maps';
  static String startingPositionMsg = 'Principio del recorrido';
  static String finalPositionMsg = 'Final del recorrido';

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  double latitude;
  double longitude;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _googleMapController;
  static LatLng _center = LatLng(-37.979858, -57.589794);
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  bool _loading = false;
  bool _showMoveBack = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Theme.of(context).primaryColor,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Selecciona la ruta'),
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
                initialCameraPosition: CameraPosition(target: _center, zoom: 15.0),
                mapType: _currentMapType,
                markers: _markers,
                onTap: _handleTap,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: <Widget>[
                      button(_getCurrentLocation, Icons.my_location, 'myLocaiton'),
                      Divider(),
                      button(_clearMarker, Icons.delete, 'erase'),
                      Divider(),
                      Visibility(
                        visible: _showMoveBack,
                        child: button(() => Navigator.pop(context, _markers), Icons.check_circle, 'done'),
                      )
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

  _clearMarker() {
    setState(() {
      _markers.clear();
      _showMoveBack = false;
    });
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

  _handleTap(LatLng point) {
    bool hasStartingPosition = false;
    bool hasFinalPosition = false;

    Marker startingMarker = Marker(
      markerId: MarkerId(Maps.startingPositionMsg),
      position: point,
      infoWindow: InfoWindow(
        title: Maps.startingPositionMsg,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    Marker finalMarker = Marker(
      markerId: MarkerId(Maps.finalPositionMsg),
      position: point,
      infoWindow: InfoWindow(
        title: Maps.finalPositionMsg,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    hasStartingPosition = _markers.toString().contains(Maps.startingPositionMsg);
    hasFinalPosition = _markers.toString().contains(Maps.finalPositionMsg);

    if (!hasStartingPosition) {
      setState(() => _markers.add(startingMarker));
    } else if (!hasFinalPosition) {
      setState(() {
        _showMoveBack = true;
        return _markers.add(finalMarker);
      });
    } else {
      return null;
    }
  }

  _getCurrentLocation() async {
    setState(() => _loading = true);
    var currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _markers.clear();
      _showMoveBack = false;
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      _markers.add(
          Marker(position: _center, infoWindow: InfoWindow(title: 'Tu ubicacion'), markerId: MarkerId('myLocaiton')));
      _loading = false;
      _googleMapController.moveCamera(CameraUpdate.newLatLng(_center));
    });
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 16.0);
  }
}
