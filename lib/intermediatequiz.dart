import 'dart:convert';

import 'models/intermediate.dart';



import 'package:flutter/material.dart';
import 'home.dart';
import 'resultpage.dart';
import 'package:flutter/services.dart';
import 'dart:async' show Future;




import 'answer.dart';

// ignore: camel_case_types
class getjson extends StatelessWidget  {
  String langname;
  getjson(this.langname);
  String assettload;
    

//loading questions
    setAsset() {
      if (langname == "Intermediate") {
        assettload = "lib/assets/intermediate.json";
      };
     
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
          return intermediatequizpage();
            }
            
        }
      
        
      );
    }
}

    class intermediatequizpage extends StatefulWidget {
      List mydata;
      Future<String> _loadData() async {
        return await rootBundle.loadString('lib/assets/intermediate.json');
      }
      
      
    _intermediatequizpageState createState() => _intermediatequizpageState(mydata);  
    }
    class _intermediatequizpageState extends State<intermediatequizpage>{
    Future loadData() async {
      String jsonString = await loadData();
      final jsonResponse = json.decode(jsonString);
      Intermediate begin = new Intermediate.fromJson(jsonResponse);
      
    }  
    var mydata;
    _intermediatequizpageState(this.mydata);


  
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
                        : (_questions[_questionIndex]['hint']),
                        
                    style: TextStyle(
                      fontSize: 12.0,
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
    "question": "Which of the following is a valid variable?",
    "answers": [
      {"answerText":" var@", "score": false},
      {"answerText": "32var", "score": false},
      {"answerText": "class", "score": false},
      {"answerText": "abc_a_c","score": true}
    ],
    "hint":"none"
  },
  
  {
    "question": "Which of the following blocks allows you to handle the errors?",
    "answers": [
      {"answerText":" except block", "score": true},
      {"answerText": "try block", "score": false},
      {"answerText": "finally block", "score": false},
      {"answerText": "None of the above","score": false}
    ],
    "hint":"The except block allows you to handle the errors."
  },

  
  {
    "question": "In the Python Programming Language, syntax error is detected by ______ at _________",
    "answers": [
      {"answerText":" Interpreter / Compile time", "score": false},
      {"answerText": "Run time . Interpreter", "score": false},
      {"answerText": "Interpreter / Run time", "score": true},
      {"answerText": "Compile time / Run time","score": false}
    ],
    "hint":"In the Python Programming Language, the interpreter can detect a syntax error at run time. The syntax error is a spelling-like mistake in the source code."
  },

  
  {
    "question": "Which of these are keywords?",
    "answers": [
      {"answerText":" in", "score": false},
      {"answerText": "is", "score": false},
      {"answerText": "assert", "score": false},
      {"answerText": "All of the above","score": true}
    ],
    "hint":"All 'in', 'is' and 'assert' are keywords"
  },

  
  {
    "question": "Which of the following is correctly evaluated for this function?",
    "answers": [
      {"answerText":"(x**y) / z", "score": false},
      {"answerText": "(x / y) * z", "score": false},
      {"answerText": "(x**y) % z", "score": true},
      {"answerText": "(x / y) / z","score": false}
    ],
    "hint":"none"
  },

  
  {
    "question": "Python was developed by?",
    "answers": [
      {"answerText":" Guido van Rossum", "score": true},
      {"answerText": "James Gosling", "score": false},
      {"answerText": "Dennis Ritchie", "score": false},
      {"answerText": "Bjarne Stroustrup","score": false}
    ],
    "hint":"none"
  },

  
  {
    "question": "Why are local variable names beginning with an underscore discouraged?",
    "answers": [
      {"answerText":"They confuse the interpreter", "score": false},
      {"answerText": "They are used to indicate a private variable of a class", "score": true},
      {"answerText": "They are used to indicate global variables", "score": false},
      {"answerText": "They slow down execution","score": false}
    ],
    "hint":"Local variable names beginning with an underscore discouraged because they are used to indicate a private variables of a class."
  },

  
  {
    "question": "What will be the output of the following code? /n x = 12 /n for i in x: /n print(i)",
    "answers": [
      {"answerText":"12", "score": false},
      {"answerText": "1 2", "score": false},
      {"answerText": "Error", "score": true},
      {"answerText": "None of the above","score": false}
    ],
    "hint":"Objects of type 'int' are not iterable."
  },

  
  {
    "question": "In which year was the Python 3.0 version developed?",
    "answers": [
      {"answerText":" 2008", "score": true},
      {"answerText": "2000", "score": false},
      {"answerText": "2010", "score": false},
      {"answerText": "2005","score": false}
    ],
    "hint":"none"
  },

  
  {
    "question": " A variable that is defined inside a method and belongs only to the current instance of a class is known as??",
    "answers": [
      {"answerText":"Inheritable", "score": false},
      {"answerText": "Instance variable", "score": true},
      {"answerText": "Function overloading", "score": false},
      {"answerText": "Instantiation","score": false}
    ],
    "hint":"none"
  },
  
  {
    "question": "Which of the following words cannot be a variable in the python language?",
    "answers": [
      {"answerText":"_val", "score": false},
      {"answerText": "val", "score": false},
      {"answerText": "try", "score": true},
      {"answerText": "_try_","score": false}
    ],
    "hint":"'try; is a keyword"
  },

  {
    "question": "Which of the following words cannot be a variable in the python language?",
    "answers": [
      {"answerText":"_val", "score": false},
      {"answerText": "val", "score": false},
      {"answerText": "try", "score": true},
      {"answerText": "_try_","score": false}
    ],
    "hint":"'try' is a keyword"
  },

  {
    "question": "What is a variable defined outside a function referred to as?",
    "answers": [
      {"answerText":"Local variable", "score": false},
      {"answerText": "Global variable", "score": true},
      {"answerText": "Static variable", "score": false},
      {"answerText": "Automatic variable","score": false}
    ],
    "hint":"' Variable defined outside a function is referred as Global variable and can be accessible by other functions."
  },

  {
    "question": " Suppose a user wants to print the second value of an array with 5 elements. What will be the syntax of the second value of the array?",
    "answers": [
      {"answerText":"array[2]", "score": false},
      {"answerText": "array[1]", "score": true},
      {"answerText": "array[-1]", "score": false},
      {"answerText": "array[-2]","score": false}
    ],
    "hint":" The index of the array starts with 0."
  },

  {
    "question": "Which of the following operators is the correct option for power(ab)?",
    "answers": [
      {"answerText":"a ^ b", "score": false},
      {"answerText": "a**b", "score": true},
      {"answerText": "a ^ ^ b", "score": false},
      {"answerText": "a ^ * b","score": false}
    ],
    "hint":"'The power operator in python is a**b, i.e., 2**3=8."
  },

  {
    "question": "Which of the following words cannot be a variable in the python language?",
    "answers": [
      {"answerText":"_val", "score": false},
      {"answerText": "val", "score": false},
      {"answerText": "try", "score": true},
      {"answerText": "_try_","score": false}
    ],
    "hint":"'try; is a keyword"
  },

  {
    "question": "Which of the following is the use of id() function in python?",
    "answers": [
      {"answerText":"Every object doesn't have a unique id", "score": false},
      {"answerText": "Id returns the identity of the object", "score": true},
      {"answerText": "All of the above mentioned", "score": false},
      {"answerText": "None of the above mentioned","score": false}
    ],
    "hint":"none"
  },

  {
    "question": "Python was developed in which year?",
    "answers": [
      {"answerText":" 1972", "score": false},
      {"answerText": "1995", "score": false},
      {"answerText": "1989", "score": true},
      {"answerText": "1981","score": false}
    ],
    "hint":"none"
  },

  {
    "question": "Which of this statement will give an error?",
    "answers": [
      {"answerText":" a++", "score": true},
      {"answerText": "++a", "score": false},
      {"answerText": "a+1", "score": false},
      {"answerText": "Both A and B","score": false}
    ],
    "hint":"none"
  },

  {
    "question": "Which of the following is true for the variable names in Python?",
    "answers": [
      {"answerText":" Unlimited length", "score": true},
      {"answerText": "All private members must have leading and trailing underscores", "score": false},
      {"answerText": "Underscore and ampersand are the only two special characters allowed", "score": false},
      {"answerText": "None of the above mentioned","score": false}
    ],
    "hint":"Variable names can be of any length."
    },

    {
      "question": "The output to execute string.ascii_letters can also be obtained from:?",
      "answers": [
        {"answerText":"character", "score": false},
        {"answerText": "ascii_lowercase_string.digits", "score": false},
        {"answerText": "lowercase_string.uppercase", "score": false},
        {"answerText": "ascii_lowercase+string.ascii_uppercase","score": true}
      ],
      "hint":"none"
    },

    {
      "question": "Which operator is used in Python to import modules from packages?",
      "answers": [
        {"answerText":" .", "score": true},
        {"answerText": "*", "score": false},
        {"answerText": "->", "score": false},
        {"answerText": "&","score": false}
      ],
      "hint":"Operator is used in Python to import modules from packages."
    }
];


