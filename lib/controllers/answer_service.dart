import 'dart:convert';

import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/questionnaire.dart';

class AnswerService{
  Future<bool> sendAnswers(QID ,List<Answer> answers, LocationData position) async {
    String list_answers = jsonEncode(answers);
    final response = await post(Uri.parse(Constants.BASE_URL+'save_answers.php'),
        body: <String, String>{
          'QID' : QID.toString() ,
          'latitude' : position.latitude.toString() ,
          'longitude' : position.longitude.toString() ,
          'answers': list_answers
        }
    );

    if (response.statusCode == 200) {
      if(response.body == "1") {
        return true;
      }
    }
    return false;
  }
  Future<List<Answer>> getCurrentUserAnswersByQID(Questionnaire q) async {
    final response = await post(Uri.parse(Constants.BASE_URL+'get_current_user_answers_by_q.php'),
        body: <String, String>{
          'QID' : q.toString() ,
          'UID' : CurrentUser.user.uid ,
        }
    );

    List<Answer> answers =  [] ;
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      answers = await List<Answer>.from(l.map((model)=> Answer.fromJsonAndCurrentUser(model)));
      answers.forEach((answer) {
        Question question = q.questions.where((qst) => qst.questionId == answer.question.questionId ).first;
        answer.question = question;
      });
    }
    return answers;
  }
}
