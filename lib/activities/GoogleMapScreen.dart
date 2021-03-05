import 'dart:async';
import 'dart:collection';

import 'package:thingsuptrackapp/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  GoogleMapScreenState createState() => GoogleMapScreenState();
}

class GoogleMapScreenState extends State<GoogleMapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  Set<Polygon> _polygons=new HashSet<Polygon>();
  Set<Marker> _markers=new HashSet<Marker>();
  List<LatLng> listofLatLngs=new List();
  int _polygonIdCounter=1;
  int _markerIdCounter=1;
  bool _serviceEnabled;



  LatLng _center=new LatLng(18.6, 73.7);
  BitmapDescriptor customIcon1;

  @override
  void initState() {
    super.initState();


  }


  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    getMarker();
  }


  void _setPolygon() {
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygons.add(
        Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: listofLatLngs,
          strokeWidth: 5,
          strokeColor: global.darkGreyColor,
          fillColor: global.darkGreyColor.withOpacity(0.15),
        ));
  }

  void getMarker()
  {
//    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(5, 5)), 'assets/marker-icon.png').then((icon) {
//
//      setState(() {customIcon1 = icon;});
//
//    });
  }

  void _setMarkers(LatLng point) {



    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(
        Marker(
          icon: customIcon1,
          markerId: MarkerId(markerIdVal),
          position: point,
          anchor: Offset(0.5,0.5)
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          polygons: _polygons,
          markers: _markers,
          onTap: (point){
            listofLatLngs.add(point);
            setState(() {
              _setMarkers(point);
              _setPolygon();
            });
          },
        ),
      ),
    );
  }
}