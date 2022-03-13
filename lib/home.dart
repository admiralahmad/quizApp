import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentor_quiz_app_tut/quizpage.dart';   
   
   
class homepage extends StatefulWidget {
  @override
  _homepageState createState() => _homepageState();
}   

class _homepageState extends State<homepage>{

  
   
   List<String> images = [
    "lib/images/python.png",
        "lib/images/python.png",
        "lib/images/python.png"
  ];
  List<String> des = [
    "This is for those with little to no experience",
    "This is for those with average knowledge",
    "This is for the masters",
   
  ];
  List<String> langname = [
    "Beginner",
    "Intermediate",
    "Advanced"
  ];

  Widget customcard(String langname, String image, String des) {
    return Padding(
      padding: EdgeInsets.all(
        20.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: ((context) => getjson(langname))
          ));
        },
        child: Material(
          color: Color.fromARGB(255, 63, 63, 65),
          elevation: 10.0,
          borderRadius: BorderRadius.circular(50.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                child: Material(
                  elevation:5.0,
                  borderRadius: BorderRadius.circular(200.0),
                   child: Container(
                     height: 150.0,
                     width: 150.0,
                     child: ClipOval(
                       child: Image(
                         fit: BoxFit.cover,
                         image: AssetImage(image),
                       ),
                     ),
                   ),
                   ),  
                ),
                Center(
                  child: Text(
                    langname,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontFamily: "Quando",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    des,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontFamily: "Alike",
                    ),
                    maxLines: 5,
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]
    );
    return Scaffold (
      appBar: AppBar(
        title: Text(
          "PyQuiz",
        ),
      ),
      body: ListView(
        children: <Widget>[
          customcard("Beginner", "lib/images/python.png", des[0]),
          customcard("Intermediate", "lib/images/python.png", des[1]),
          customcard("Advanced", "lib/images/python.png", des[2]),
          
        ],
      ),
      );
  }

  
}