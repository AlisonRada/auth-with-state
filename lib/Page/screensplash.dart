import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Icon(Icons.school,
            size: 200.0,
            color: Color.fromRGBO(140, 0, 75, 1),
          )),
    );
  }
}