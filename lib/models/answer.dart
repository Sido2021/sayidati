import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/user.dart';

class Answer {
  User user = CurrentUser.user;
  Question question = Question.Empty();
  String answer = "";

  Answer(this.user, this.question, this.answer);

  Answer.Empty();

  Answer.fromJsonAndCurrentUser(Map<String, dynamic> json)
      : user = CurrentUser.user,
        question = Question.fromID(int.parse(json['QuestionID'])),
        answer = json['Answer'];

  Answer.fromJson(Map<String, dynamic> json)
      : user = User(json['UID'], json['Email'], json['Name'], json['Gender'],
            json['DateOfBirth'], json['ImageUrl']),
        question = Question(json['QuestionID'], json['QuestionTypeId'], json['Title'],json['NextQuestionID'],json['Required']),
        answer = json['answer'];

  Map<String , dynamic> toJson() => {
    'UID' : user.uid ,
    'QuestionID' : question.questionId ,
    'Answer' : answer
  };

  bool isEmpty()=> question.isEmpty() ;
}
