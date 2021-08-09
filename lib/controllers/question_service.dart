import 'dart:convert';

import 'package:http/http.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/models/question.dart';

class QuestionService{
  Future<List<Question>> getQuestions(int QID) async {
    List<Question> questions = [] ;
    final response = await post(Uri.parse(Constants.BASE_URL+'get_questions.php'),
        body: jsonEncode(<String, int>{
          'QID': QID
        }
        )
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      questions = await List<Question>.from(l.map((model)=> Question.fromJson(model)));
    }
    return questions;
  }
}
