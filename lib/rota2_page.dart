import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:permission/permission.dart';

class RotaPage2 extends StatefulWidget {
  @override
  _RotaPage2State createState() => _RotaPage2State();
}

class _RotaPage2State extends State<RotaPage2> {
  //Controlador do Mapa
  Completer<GoogleMapController> _controller = Completer();
  //Foco inicial do mapa
  static const LatLng _divinopolis = const LatLng(-20.1394, -44.8872);
  //Lista de pontos no Mapa
  List<Marker> _pontosNoMapa = [];

  Set<Polyline> polyline = {};
  List<LatLng> rotas = [];
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: 'AIzaSyC8K61M168zrcw3wpJ-dWEpkSt8tcJ_sz0');

  void _montaRota() async {
    var permissao =
        await Permission.getPermissionsStatus([PermissionName.Location]);

    if (permissao[0].permissionStatus == PermissionStatus.notAgain) {
      var solicitacao =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      rotas = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(-20.165434, -44.846818), //Casa
          destination: LatLng(-20.171170, -44.909911), //cefet
          mode: RouteMode.driving);
    }
  }

  void _montaPontosNoMapa(){
    _pontosNoMapa.add(Marker(
      markerId: MarkerId('MinhaCasa'),
      infoWindow:  InfoWindow(title: 'Minha Casa',snippet: 'Descrição'),
      draggable: false,
      onTap: () {
        print('Clicou no Ponto Minha Casa');
      },
      position: LatLng(-20.165434, -44.846818),
    ));

    _pontosNoMapa.add(Marker(
      markerId: MarkerId('Cefet'),
      infoWindow:  InfoWindow(title: 'Cefet',snippet: 'Descrição'),
      draggable: false,
      onTap: () {
        print('Clicou no Ponto Cefet');
      },
      position: LatLng(-20.171170, -44.909911),
    ));
  }
  void getRotaComEndereco() async {
    var enderecos = await googleMapPolyline.getPolylineCoordinatesWithAddress(
        origin: 'Rua Antonina Maria Pereira, 171, Davanuze',
        destination:
            'R. Álvares de Azevedo, 400 - Bela Vista, Divinópolis - MG, 35503-822',
        mode: RouteMode.driving);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);

      _montaPontosNoMapa();
      _montaRota();

      polyline.add(Polyline(
          polylineId: PolylineId('trabalho'),
          visible: true,
          points: rotas,
          width: 4,
          color: Colors.blue,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
    });
  }

  @override
  void initState() {
    super.initState();
    //montaRota();
    getRotaComEndereco();
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
            polylines: polyline,
            mapType: MapType.normal,
            initialCameraPosition:
                CameraPosition(target: _divinopolis, zoom: 12.0),
            markers: Set.from(_pontosNoMapa),
            myLocationEnabled: true,
            compassEnabled: true,
          ),
        )));
  }
}
