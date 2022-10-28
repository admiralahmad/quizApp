class Beginner{
  List<String> answers; 
String question,hint;

Beginner({ this.question,  this.answers,  this.hint});
factory Beginner.fromJson(Map<String, dynamic> json){
return Beginner(
  question: json['question'],
  answers: json['answers'],
  hint: json['hint'],
);
}
}