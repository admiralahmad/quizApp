import 'package:flutter/material.dart';
import 'home.dart';
import 'splash.dart';


void main()  {
  
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PyQuiz',
      theme: ThemeData(
        primaryColor: Color(0xFF55C1EF),
      ),
      home: splashscreen(),
    );
  }
}


