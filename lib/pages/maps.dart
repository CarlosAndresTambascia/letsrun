import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:letsrun/models/location.dart';

class Maps extends StatefulWidget {
  static String id = 'maps';
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  double latitude;
  double longitude;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(45.512563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Selecciona la ruta'),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    button(_onMapTypeButtonPressed, Icons.map),
                    SizedBox(
                      height: 16.0,
                    ),
                    //button(_onAddMarkerButtonPressed, Icons.add_location),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    latitude = location.latitude;
    longitude = location.longitude;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(icon, size: 36.0),
    );
  }

  _onMapTypeButtonPressed() {
    setState(() => _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal);
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(_lastMapPosition.toString()),
            position: _lastMapPosition,
            infoWindow: InfoWindow(title: 'Esta es la posicion inicial'),
            icon: BitmapDescriptor.defaultMarker),
      );
    });
  }
}
