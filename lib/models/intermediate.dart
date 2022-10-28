class Intermediate{
  List<String> answers; 
String question,hint;

Intermediate({ this.question,  this.answers,  this.hint});
factory Intermediate.fromJson(Map<String, dynamic> json){
return Intermediate(
  question: json['question'],
  answers: json['answers'],
  hint: json['hint'],
);
}
}