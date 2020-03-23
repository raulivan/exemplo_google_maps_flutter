import 'package:exemplo_google_maps/rota_page.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'pesquisa_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: RotaPage(),
    );
  }
}
