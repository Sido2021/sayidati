import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/models/user.dart';

class Answer {
  String answerId = "";
  String uid = "";
  String questionnaireId = "";
  String latitude = "" ;
  String longitude = "" ;

  Answer(this.answerId,this.uid, this.questionnaireId, this.latitude,this.longitude);

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
