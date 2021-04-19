import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salla/shared/style/colors.dart';

TextStyle black14() => TextStyle(fontSize: 14);

TextStyle black12() => TextStyle(fontSize: 12);

TextStyle black16() => TextStyle(fontSize: 16);

TextStyle black18() => TextStyle(fontSize: 18);

TextStyle black20() => TextStyle(fontSize: 20);

TextStyle black22() => TextStyle(fontSize: 22);

TextStyle white14() => TextStyle(fontSize: 14, color: Colors.white);

TextStyle white12() => TextStyle(fontSize: 12, color: Colors.white);
TextStyle white10() => TextStyle(fontSize: 10, color: Colors.white);

TextStyle white16() => TextStyle(fontSize: 16, color: Colors.white);

TextStyle white18() => TextStyle(fontSize: 18, color: Colors.white);

TextStyle white20() => TextStyle(fontSize: 20, color: Colors.white);

TextStyle white22() => TextStyle(fontSize: 22, color: Colors.white);

TextStyle grey12() => TextStyle(fontSize: 12, color: Colors.grey);

TextStyle grey14() => TextStyle(fontSize: 14, color: Colors.grey);

TextStyle grey16() => TextStyle(fontSize: 16, color: Colors.grey);

TextStyle grey18() => TextStyle(fontSize: 18, color: Colors.grey);

TextStyle grey20() => TextStyle(fontSize: 20, color: Colors.grey);

TextStyle grey22() => TextStyle(fontSize: 22, color: Colors.grey);

ThemeData lightThem() => ThemeData(
      fontFamily: 'jannah',
      appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
            fontFamily: 'jannah',
            fontSize: 20,
          )
        ),
        elevation: 0
      ),

  scaffoldBackgroundColor: Colors.white,


    );
