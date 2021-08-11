import 'dart:convert';

import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/question_type.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      answers = await jsonToList(q , response.body);
    }
    return answers;
  }

  Future<List<Answer>> getAnswersFromLocal(q) async {
    List<Answer> answers =  [] ;
    final prefs = await SharedPreferences.getInstance();
    final answers_json = prefs.getString('answers') ?? "";
    if(answers_json != ""){
      print(answers_json);
      answers = await jsonToList(q,answers_json);
    }
    return answers;
  }

  Future<void> saveAnswersToLocal(List<Answer> answers) async{
    var answers_json = jsonEncode(answers.map((e) => e.toJson()).toList());
    print(answers_json);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool res = await prefs.setString('answers', answers_json);
  }

  Future<List<Answer>> jsonToList(q , response) async {
    List<Answer> answers =  [] ;
    Iterable l = json.decode(response);
    answers = await List<Answer>.from(l.map((model)=> Answer.fromJsonAndCurrentUser(model)));
    answers.forEach((answer) {
      Question question = q.questions.firstWhere((qst) => qst.questionId == answer.question.questionId , orElse: ()=> Question.Empty());
      if(!question.isEmpty())answer.question = question;
    });
    return answers;
  }
}
