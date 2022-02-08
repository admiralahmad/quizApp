import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizApp/resultpage.dart';

class getjson extends StatelessWidget {
  String langname;
  getjson(this.langname);
   String assettoload;
  

  // a function
  // sets the asset to a particular JSON file
  // and opens the JSON
  setasset() {
    if (langname == "Python") {
      assettoload = "assets/python.json";
    } else if (langname == "Java") {
      assettoload = "assets/java.json";
    } else {
      assettoload = "assets/js.json";
    }

FutureBuilder(builder: builder)