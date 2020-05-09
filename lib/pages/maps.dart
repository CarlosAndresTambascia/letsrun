import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Maps extends StatefulWidget {
  static String id = 'maps';

  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  double latitude;
  double longitude;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _googleMapController;
  static LatLng _center = LatLng(45.512563, -122.677433);
  final Set<Marker> _markers = {};
  MapType _currentMapType = MapType.normal;
  bool _loading = false;
  final String _startingPositionMsg = 'Principio del recorrido';
  final String _finalPositionMsg = 'Final del recorrido';
  bool _showMoveBack = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
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
                      SizedBox(height: 16.0),
                      button(_clearMarker, Icons.delete, 'erase'),
                      SizedBox(height: 16.0),
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
      markerId: MarkerId(_startingPositionMsg),
      position: point,
      infoWindow: InfoWindow(
        title: _startingPositionMsg,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    Marker finalMarker = Marker(
      markerId: MarkerId(_finalPositionMsg),
      position: point,
      infoWindow: InfoWindow(
        title: _finalPositionMsg,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    hasStartingPosition = _markers.toString().contains(_startingPositionMsg);
    hasFinalPosition = _markers.toString().contains(_finalPositionMsg);

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
