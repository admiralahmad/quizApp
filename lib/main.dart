import 'package:flutter/material.dart';
import 'package:flutter_mentor_quiz_app_tut/home.dart';
import 'package:flutter_mentor_quiz_app_tut/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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


