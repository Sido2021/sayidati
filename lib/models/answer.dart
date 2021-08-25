import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/models/user.dart';
import 'package:uuid/uuid.dart';

class Answer {
  String answerId = "";
  String uid = "";
  String questionnaireId = "";
  String latitude = "" ;
  String longitude = "" ;


  List<Question> questionsAnswers = [] ;

  Answer(this.answerId,this.uid, this.questionnaireId, this.latitude,this.longitude);
  Answer.newAnswer(){
    answerId = Uuid().v4();
  }
  Answer.fromJson(Map<String, dynamic> json)
      : answerId = json['AnswerID'],
        uid = json['UID'],
        questionnaireId = json['QID'],
        latitude = json['Latitude'],
        longitude = json['Longitude']
        ;

  Map<String , dynamic> toJson() => {
    'AnswerID' : answerId,
    'UID' : uid ,
    'QID' : questionnaireId,
    'latitude' : longitude,
    'longitude' : longitude
  };

}
