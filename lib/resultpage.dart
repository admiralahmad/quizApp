// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'home.dart';
import 'intermediatequiz.dart';


class resultpage extends StatelessWidget {
  final int _totalScore;

  resultpage(this._totalScore);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Results"
        ),
      ),
      body:Center(
        child: 
        Column(
        children:[
        Container(
                padding: EdgeInsets.all(20.0),
                color: Colors.white,
                child: Center(
                  child: Text(
                    
                    _totalScore > 4
                        ? '   Congratulations! Your final score is: $_totalScore'
                        : '   Your final score is: $_totalScore. Better luck next time!',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: _totalScore > 4 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),

             

              RaisedButton(onPressed:(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => homepage(),)
              );
                homepage();
             }, child: new Text('  Exit  '),
             padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 100.0
             
             ),
             
             )
            ]
              ) 
        ,
    ));
  }

}
