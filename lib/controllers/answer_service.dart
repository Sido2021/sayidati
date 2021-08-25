import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/answer_details.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/question_type.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AnswerService{
  Future<bool> sendAnswers(QID ,Answer answer, latitude , longitude ) async {
    print(jsonEncode(answer.questionsAnswers));
    final response = await post(Uri.parse(Constants.BASE_URL+'save_answers.php'),
        body: <String, String>{
          'AnswerID' :answer.answerId,
          'UID' : CurrentUser.user.uid,
          'QID' : QID.toString() ,
          'latitude' : latitude,
          'longitude' : longitude ,
          'answers': jsonEncode(answer.questionsAnswers)
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
          'QID' : q.QID.toString() ,
          'UID' : CurrentUser.user.uid ,
        }
    );

    List<Answer> answers =  [] ;
    if (response.statusCode == 200) {
      answers = await jsonToList(response.body);
    }
    return answers;
  }

  Future<List<Question>> getQuestionsAnswers(Answer answer) async {
    final response = await post(Uri.parse(Constants.BASE_URL+'get_answer_details_list.php'),
        body: <String, String>{
          'AnswerID' : answer.answerId ,
        }
    );

    List<Question> answersDetailsList =  [] ;
    if (response.statusCode == 200) {
      answersDetailsList = await jsonToAnswerDetailsList(response.body);
    }
    return answersDetailsList;
  }

  /*Future<List<Answer>> getAnswersFromLocal(q) async {
    List<Answer> answers =  [] ;
    final prefs = await SharedPreferences.getInstance();
    final answers_json = prefs.getString('answers-'+q.toString()) ?? "";
    if(answers_json != ""){
      print(answers_json);
      answers = await jsonToList(q,answers_json);
    }
    return answers;
  }*/

  Future<void> saveAnswersToLocal(List<Answer> answers , QID) async{
    var answers_json = jsonEncode(answers.map((e) => e.toJson()).toList());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString('answers-'+QID.toString(), answers_json);
  }
  Future<void> removeAnswersFromLocal(QID) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.remove('answers-'+QID.toString());
  }
 
  Future<List<Answer>> jsonToList(response) async {
    List<Answer> answers =  [] ;
    Iterable l = json.decode(response);
    answers = await List<Answer>.from(l.map((model)=> Answer.fromJson(model)));
    return answers;
  }
  Future<List<Question>> jsonToAnswerDetailsList(response) async {
    List<Question> answersDetailsList =  [] ;
    Iterable l = json.decode(response);
    answersDetailsList = await List<Question>.from(l.map((model)=> Question.fromJson(model['Question'])));
    return answersDetailsList;
  }
}
