import 'package:sayidati/controllers/question_service.dart';
import 'package:sayidati/controllers/questionnaire_service.dart';
import 'package:sayidati/models/question.dart';

class Questionnaire {
  int QID ;
  String label ;
  String dateOfPublish ;

  List<Question> questions = [] ;

  Questionnaire(this.QID, this.label, this.dateOfPublish);

  Questionnaire.fromJson(Map<String , dynamic> json)
      : QID = int.parse(json['QID']),
        label = json['Label'],
        dateOfPublish = json['DateOfPublish']
  ;

  Map<String , dynamic> toJson() => {
    'QID' : QID ,
    'Label' : label ,
    'DateOfPublish' : dateOfPublish
  };

  loadQuestions() async {
    QuestionService questionService = QuestionService();
    questions = await questionService.getQuestions(this.QID);
  }

  bool isFirstQuestion(question){
    return questions.indexOf(question) == 0;
  }
}