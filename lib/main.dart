import 'package:flutter/material.dart';
import 'package:salla/modules/boarding/boarding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'jannah'
      ),
      home: BoardingScreen(),
    );
  }
}

