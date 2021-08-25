import 'dart:convert';

import 'package:http/http.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/models/question.dart';

class QuestionService{
  Future<List<Question>> getQuestions(int QID) async {
    List<Question> questions = [] ;
    final response = await post(Uri.parse(Constants.BASE_URL+'get_questions.php'),
        body:<String, String>{
          'QID': QID.toString()
        }
    );

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      questions = await List<Question>.from(l.map((model)=> Question.fromJson(model)));
      await organisation(questions);

    }
    return questions;
  }

  Future<void> organisation(questions) async {
    for(int i = 0 ; i<questions.length ; i++){
      Question question = questions[i];
      question.options.forEach((option) {
        if(option.hasNextQuestion()){
          Question targetQuestion = questions.firstWhere((q) => q.questionId == option.nextQuestionId , orElse: ()=> Question.Empty() );
          if(!targetQuestion.isEmpty()){
            option.nextQuestion = targetQuestion ;
            questions.remove(targetQuestion);
          }
        }
      });
    }
  }
}
