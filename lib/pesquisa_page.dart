import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PesquisaPage extends StatefulWidget {
  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _divinopolis = const LatLng(-20.1394, -44.8872);

  MapType _tipoMapa = MapType.normal;

  List<Marker> _pontosNoMapa = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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
      body: ListView(
        children: <Widget>[
          TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisa',
              ),
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left),
          RaisedButton(child: Icon(Icons.search), onPressed: () {}),
          Center(
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
          ))
        ],
      ),
    );
  }


void pesquisar(double latitude, double longitude) async {
  var _API_KEY = 'AIzaSyC8K61M168zrcw3wpJ-dWEpkSt8tcJ_sz0';

  setState(() {
    _pontosNoMapa.clear(); 
  });
  // 3
  String url =
      '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=10000&keyword=${widget.keyword}';
  print(url);
  // 4
  final response = await http.get(url);
  // 5
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    _handleResponse(data);
  } else {
    throw Exception('An error occurred getting places nearby');
  }
  setState(() {
    searching = false; // 6
  });
}

}
