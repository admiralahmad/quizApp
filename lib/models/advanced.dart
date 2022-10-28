class Advanced{
  List<String> answers; 
String question,hint;

Advanced({ this.question,  this.answers,  this.hint});
factory Advanced.fromJson(Map<String, dynamic> json){
return Advanced(
  question: json['question'],
  answers: json['answers'],
  hint: json['hint'],
<<<<<<< Updated upstream
  );
=======
);
>>>>>>> Stashed changes
}
}
