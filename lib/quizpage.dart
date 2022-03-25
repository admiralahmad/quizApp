import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mentor_quiz_app_tut/home.dart';
import 'package:flutter_mentor_quiz_app_tut/resultpage.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'answer.dart';

// ignore: camel_case_types
class getjson extends StatelessWidget  {
  String langname;
  getjson(this.langname);
  String assettload;
    

//loading questions
    setAsset() {
      if (langname == "Beginner") {
        assettload = "lib/assets/beginner.json";
      }
      else if (langname == "Intermediate") {
        assettload = "lib/assets/intermediate.json";
    }
    else {
      assettload = "lib/assets/advanced.json";
    }
    }

    Widget build(BuildContext context) {
      setAsset();
      return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString(assettload, cache: false),
        builder: (context, snapshot)
        {
          final mydata = json.decode(snapshot.data.toString());

          if (mydata == null){
            return Scaffold(
              body: Center(
                child: Text(
                  "Loading",
                  ),
                ),
                
            );
          }
            else {
          return quizpage();
            }
            
        }
      
        
      );
    }
}

    class quizpage extends StatefulWidget {
      List mydata;
      
      
      
    _quizpageState createState() => _quizpageState(mydata);  
    }
    class _quizpageState extends State<quizpage>{

    var mydata;
    _quizpageState(this.mydata);


  
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  int _totalScore = 0;
  bool answerWasSelected = false;
  bool endOfQuiz = false;
  bool correctAnswerSelected = false;

   

  void _questionAnswered(bool answerScore) {
    setState(() {
      // answer was selected
      answerWasSelected = true;
      // check if answer was correct
      if (answerScore) {
        _totalScore++;
        correctAnswerSelected = true;
      }
      // adding to the score tracker on top
      _scoreTracker.add(
        answerScore
            ? Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : Icon(
                Icons.clear,
                color: Colors.red,
              ),
      );
      //when the quiz ends
      if (_questionIndex + 1 == _questions.length) {
        endOfQuiz = true;
        setState(() {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => resultpage(_totalScore),
      ));
        });
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _questionIndex++;
      answerWasSelected = false;
      correctAnswerSelected = false;
    });
    // what happens at the end of the quiz
    if (_questionIndex >= _questions.length) {
      _resetQuiz();
    }
  }

  void _resetQuiz() {
    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => homepage(),
      ));
      _questionIndex = 0;
      _totalScore = 0;
      _scoreTracker = [];
      endOfQuiz = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async{
      bool willLeave = true;
      //show the confirm dialog
      await showDialog(context: context, 
      builder: (_) => AlertDialog(
        title: const Text('Are you sure you want to quit the quiz? All progress will be lost'),
        actions: [
          ElevatedButton(
            onPressed:() {
              willLeave = true;
              Navigator.of(context).pop();
            },
            child: const Text('Yes')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
             child: const Text('No'))
        ],
      ));
      return willLeave;  
      },
        
    
      

      child: Scaffold(
        appBar: AppBar(
          
      title: Text(
          'PyQuiz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 51, 52, 54),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back_ios),
        // onPressed:() => Navigator.of(context).;
        ),
      
      ),
      
      
      body: Center(
        child: Column(
          children: [
            Row(
              children:<Widget> [
                if (_scoreTracker.length == 0)
                  SizedBox(
                    height: 10.0,
                  ),
                if (_scoreTracker.length > 0) ..._scoreTracker
              ],
            ),
            Container(
              width: double.infinity,
              height: 115.0,
              margin: EdgeInsets.only(bottom: 50.0, left: 10.0, right: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  
                  _questions[_questionIndex]['question'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                  
                  
                ),
              ),
              
            ),
            
           
            
            
            
            ...(_questions[_questionIndex]['answers']
                    as List<Map<String, Object>>)
                .map(
              (answer) => Answer(
                answerText: answer['answerText'],
                answerColor: answerWasSelected
                    ? answer['score']
                        ? Colors.green
                        : Colors.red
                    : null,
                answerTap: () {
                  // if answer was already selected then nothing happens onTap
                  if (answerWasSelected) {
                    return;
                  }
                  //answer is being selected
                  _questionAnswered(answer['score']);
                },
              ),
            ),
            SizedBox(height: 30.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0),
                primary: Color.fromARGB(255, 82, 82, 82),
                
              ),
              onPressed: () {
                if (!answerWasSelected) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please select an answer before going to the next question'),
                  ));
                  return;
                }
                _nextQuestion();
              },
              child: Text(endOfQuiz ? 'Restart Quiz' : 'Next Question'),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                '${_totalScore.toString()}/${_questions.length}',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            if (answerWasSelected && !endOfQuiz)
            
            Expanded(
              
              child: Container(
                
                height: 50,
                width: double.infinity,
                color: correctAnswerSelected ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                   
                    correctAnswerSelected
                        ? 'Well done, you got it right!'
                        : 'Wrong :/'+ 'hint',
                        
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // if (endOfQuiz)
            
    
            //   Container(
            //     height: 50,
            //     width: double.infinity,
            //     color: Colors.white,
            //     child: Center(
            //       child: Text(
            //         _totalScore > 4
            //             ? 'Congratulations! Your final score is: $_totalScore'
            //             : 'Your final score is: $_totalScore. Better luck next time!',
            //         style: TextStyle(
            //           fontSize: 10.0,
            //           fontWeight: FontWeight.bold,
            //           color: _totalScore > 4 ? Colors.green : Colors.red,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    )
    );
  }
}

final _questions = const [
  {
    'question': 'How long is New Zealand’s Ninety Mile Beach?',
    'answers': [
      {'answerText': '88km, so 55 miles long.', 'score': true},
      {'answerText': '55km, so 34 miles long.', 'score': false},
      {'answerText': '90km, so 56 miles long.', 'score': false},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question':
        'In which month does the German festival of Oktoberfest mostly take place?',
    'answers': [
      {'answerText': 'January', 'score': false},
      {'answerText': 'October', 'score': false},
      {'answerText': 'September', 'score': true},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question': 'Who composed the music for Sonic the Hedgehog 3?',
    'answers': [
      {'answerText': 'Britney Spears', 'score': false},
      {'answerText': 'Timbaland', 'score': false},
      {'answerText': 'Michael Jackson', 'score': true},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question': 'In Georgia (the state), it’s illegal to eat what with a fork?',
    'answers': [
      {'answerText': 'Hamburgers', 'score': false},
      {'answerText': 'Fried chicken', 'score': true},
      {'answerText': 'Pizza', 'score': false},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question':
        'Which part of his body did musician Gene Simmons from Kiss insure for one million dollars?',
    'answers': [
      {'answerText': 'His tongue', 'score': true},
      {'answerText': 'His leg', 'score': false},
      {'answerText': 'His butt', 'score': false},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question': 'In which country are Panama hats made?',
    'answers': [
      {'answerText': 'Ecuador', 'score': true},
      {'answerText': 'Panama (duh)', 'score': false},
      {'answerText': 'Portugal', 'score': false},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question': 'From which country do French fries originate?',
    'answers': [
      {'answerText': 'Belgium', 'score': true},
      {'answerText': 'France (duh)', 'score': false},
      {'answerText': 'Switzerland', 'score': false},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question': 'Which sea creature has three hearts?',
    'answers': [
      {'answerText': 'Great White Sharks', 'score': false},
      {'answerText': 'Killer Whales', 'score': false},
      {'answerText': 'The Octopus', 'score': true},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
  {
    'question': 'Which European country eats the most chocolate per capita?',
    'answers': [
      {'answerText': 'Belgium', 'score': false},
      {'answerText': 'The Netherlands', 'score': false},
      {'answerText': 'Switzerland', 'score': true},
      {'answerText': '','score': false},
    ],
    'hint':''
  },
];


