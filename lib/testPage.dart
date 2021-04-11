import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  var text;
  TestPage(this.text);
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            '${widget.text}',
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ),
      ),
    );
  }
}
