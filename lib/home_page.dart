import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _divinopolis = const LatLng(-20.1394, -44.8872);

  MapType _tipoMapa = MapType.normal;

  List<Marker> _pontosNoMapa = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();

    _pontosNoMapa.add(Marker(
      markerId: MarkerId('MinhaCasa'),
      draggable: false,
      onTap: () {
        print('Clicou no Ponto Minha Casa');
      },
      position: LatLng(-20.165434, -44.846818),
    ));

    _pontosNoMapa.add(Marker(
      markerId: MarkerId('Cefet'),
      draggable: false,
      onTap: () {
        print('Clicou no Ponto Cefet');
      },
      position: LatLng(-20.171170, -44.909911),
    ));
  }

  void shopping() {
    var local = CameraPosition(
        target: LatLng(-20.127276, -44.881882),
        zoom: 20.0,
        bearing: 40.0,
        tilt: 45.0);

    _controller.future.then((mapa) {
      mapa.animateCamera(CameraUpdate.newCameraPosition(local));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
        actions: <Widget>[
          PopupMenuButton<MapType>(
            itemBuilder: (context) => <PopupMenuEntry<MapType>>[
              const PopupMenuItem<MapType>(
                child: Text('Normal'),
                value: MapType.normal,
              ),
              const PopupMenuItem<MapType>(
                child: Text('Satélite'),
                value: MapType.satellite,
              ),
              const PopupMenuItem<MapType>(
                child: Text('Hibrido'),
                value: MapType.hybrid,
              ),
              const PopupMenuItem<MapType>(
                child: Text('Terrena'),
                value: MapType.terrain,
              )
            ],
            onSelected: (selecionado) {
              setState(() {
                _tipoMapa = selecionado;
              });
            },
          )
        ],
      ),
      body: Center(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: _tipoMapa,
          initialCameraPosition:
              CameraPosition(target: _divinopolis, zoom: 12.0),
          markers: Set.from(_pontosNoMapa),
        ),
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.map),
          onPressed: () {
            shopping();
          }),
    );
  }
}
