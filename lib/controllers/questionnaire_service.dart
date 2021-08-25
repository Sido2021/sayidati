import 'dart:convert';

import 'package:http/http.dart' ;
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/questionnaire.dart';

class QuestionnaireService{
  Future<Questionnaire> getQuestionnaire() async {
    final response = await get(Uri.parse(Constants.BASE_URL));

    if (response.statusCode == 200) {
      return Questionnaire.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Questionnaire>> getAllQuestionnaires() async {
    final response = await get(Uri.parse(Constants.BASE_URL+"get_all_questionnaires.php"));

    List<Questionnaire> questionnaires = [] ;
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      questionnaires = await List<Questionnaire>.from(l.map((model)=> Questionnaire.fromJson(model)));
    }
    return questionnaires;
  }


  Future<List<Questionnaire>> getUserQuestionnaires() async {
    final response = await post(Uri.parse(Constants.BASE_URL+'get_questionnaires_by_user.php'),
        body: <String, String>{
          'UID' : CurrentUser.user.uid ,
        }
    );

    List<Questionnaire> questionnaires =  [] ;
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      questionnaires = await List<Questionnaire>.from(l.map((model)=> Questionnaire.fromJson(model)));
    }
    return questionnaires;
  }
}
