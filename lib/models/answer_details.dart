import 'package:sayidati/models/question.dart';

class AnswerDetails {
  Question question = Question.Empty();
  String answer = "";

  AnswerDetails(this.question,this.answer);
  AnswerDetails.Empty();

  AnswerDetails.fromJson(Map<String, dynamic> json)
      : question = Question.fromJson(json['Question']),
        answer = json['Answer']
  ;

  Map<String , dynamic> toJson() => {
    'QuestionID' : question.questionId,
    'Answer' : answer
  };

  bool isEmpty() => question.isEmpty();

}
