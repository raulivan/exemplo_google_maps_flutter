import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

class RotaPage extends StatefulWidget {
  @override
  _RotaPageState createState() => _RotaPageState();
}

const LatLng SOURCE_LOCATION = LatLng(-20.165434, -44.846818);
const LatLng DEST_LOCATION = LatLng(-20.171170, -44.909911);

class _RotaPageState extends State<RotaPage> {
  Completer<GoogleMapController> _controller = Completer();
// this set will hold my markers
  Set<Marker> _markers = {};
// this will hold the generated polylines
  Set<Polyline> _polylines = {};
// this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = 'AIzaSyC8K61M168zrcw3wpJ-dWEpkSt8tcJ_sz0';

 

// for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //Foco inicial do mapa
  static const LatLng _divinopolis = const LatLng(-20.1394, -44.8872);

  void _permissao() async {
     var permissao =
        await Permission.getPermissionsStatus([PermissionName.Location]);

    if (permissao[0].permissionStatus == PermissionStatus.notAgain) 
      await Permission.requestPermissions([PermissionName.Location]);
  }
  void _onMapCreated(GoogleMapController controller) {
    _permissao();
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
   setState(() {
      // Origem
      _markers.add(Marker(
         markerId: MarkerId('CASA'),
         position: SOURCE_LOCATION,
         //icon: sourceIcon
      ));
      // destino
      _markers.add(Marker(
         markerId: MarkerId('CEFET'),
         position: DEST_LOCATION,
        // icon: destinationIcon
      ));
   });
}

setPolylines() async {
   List<PointLatLng> result = await
      polylinePoints.getRouteBetweenCoordinates(
         googleAPIKey,
         SOURCE_LOCATION.latitude, 
         SOURCE_LOCATION.longitude,
         DEST_LOCATION.latitude, 
         DEST_LOCATION.longitude);
   if(result.isNotEmpty){
      result.forEach((PointLatLng point){
         polylineCoordinates.add(
            LatLng(point.latitude, point.longitude));
      });
   }
   setState(() {
      Polyline polyline = Polyline(
         polylineId: PolylineId('poly'),
         color: Color.fromARGB(255, 40, 122, 198),
         points: polylineCoordinates
      );
 
      _polylines.add(polyline);
    });
}

  @override
  void initState() {
    super.initState();
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/driving_pin.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/destination_map_marker.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: <Widget>[
            Icon(Icons.map),
            Text('Google Maps'),
          ],
        )),
        body: Center(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(target: _divinopolis, zoom: 12.0),
            markers: _markers,
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false
          ),
        )));
  }
}
