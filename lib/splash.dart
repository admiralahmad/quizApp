import 'dart:async';

import 'package:flutter/material.dart';
import 'home.dart';
import 'intermediatequiz.dart';


class splashscreen extends StatefulWidget {
  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => homepage(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
           gradient: LinearGradient(
	                  colors: 
                    [
	                    Color.fromRGBO(143, 148, 251, 1),
	                    Color.fromRGBO(143, 148, 251, .6),
	                  ]            

          )
          ),
          child: Center(
            child: Text(
          "PyQuiz",
          style: TextStyle(
            fontSize: 50.0,
            color: Colors.white,
            fontFamily: "Satisfy",
          ),
        ))));
  }
}
