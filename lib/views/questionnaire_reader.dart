import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/Utilities/location.dart';
import 'package:sayidati/controllers/answer_service.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/question_type.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/widgets/done.dart';
import 'package:sayidati/widgets/finish_dialog.dart';
import 'package:sayidati/widgets/date_box.dart';
import 'package:sayidati/widgets/question_input_box.dart';
import 'package:sayidati/widgets/question_multiple_choices_list.dart';
import 'package:sayidati/widgets/question_single_choices_list.dart';
import 'package:sayidati/widgets/questionnaire_body.dart';
import 'package:sayidati/widgets/questionnaire_head.dart';

class QuestionnaireReader extends StatefulWidget {
  Questionnaire questionnaire ;
  QuestionnaireReader(this.questionnaire);
  _QuestionnaireReaderState createState() => _QuestionnaireReaderState();
}

class _QuestionnaireReaderState extends State<QuestionnaireReader> {

  Question currentQuestion = Question.Empty();
  bool buttonEnabled = false ;
  bool firstCall = false ;
  bool completed = false;
  bool sendingAnswers = false ;
  String answer= "" ;
  bool checkedValue = false  ;
  bool doneStep = false ;
  bool loadCompleted = false ;
  DateTime? selectedDate ;

  List<Answer> answers = [] ;
  List<Question> previousQuestions = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadQuestionsAnswers();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child  : Column(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height * 0.7,
                      child: loadCompleted ? showQuestionnaire() : showProgress(),
                    )
            ]

      ),
      ),
        ),
      ),
    );
  }

  void loadQuestionsAnswers() async {
    await widget.questionnaire.loadQuestions();
    AnswerService answerService = AnswerService();
    answers = await answerService.getCurrentUserAnswersByQID(widget.questionnaire);
    currentQuestion = widget.questionnaire.questions[0];
    loadCompleted = true ;
    loadCurrentQuestion();
  }

  showQuestionnaire() {
    return Center(
      child: SizedBox.expand(
          child:
          Column(
            children: [
              QuestionnaireHead(widget.questionnaire),
              QuestionnaireBody(widget.questionnaire,currentQuestion,answerBox,next,buttonEnabled,previous)
            ],
          )
      ),
    ) ;
  }

  answerBox() {
    switch(currentQuestion.typeId){
      case 1 : return questionInputBox(changeAnswerText,controller,false);
      case 2 : return getMultipleChoicesList(currentQuestion,changeAnswerText , answer , false );
      case 3 : return getSingleChoicesList(currentQuestion , changeOptionsSelection ,answer,false);
      case 4 : return dateBox(context ,selectedDate , changeDate,false);
    }
  }

  next(){
    setState(() {
      previousQuestions.add(currentQuestion);
      clean();
      int nextQ = 0 ;
      if(currentQuestion.typeId == QuestionType.SINGLE_CHOICE_TYPE){
        if(currentQuestion.selectedOption().nextQuestionId != 0){
          nextQ = currentQuestion.selectedOption().nextQuestionId ;
        }
      }
      else {
        if(currentQuestion.nextQuestionId != 0){
          nextQ = currentQuestion.nextQuestionId ;
        }
      }

      if(nextQ != 0){
        currentQuestion = widget.questionnaire.questions.firstWhere((element) => element.questionId == nextQ) ;
        checkAnswerForCurrentQuestion();
        loadCurrentQuestion();
      }
      else {
        //showFinishDialog(context,saveAnswers);
      }
    });
  }

  previous(){
      currentQuestion = previousQuestions.last;
      previousQuestions.remove(previousQuestions.last);
      loadCurrentQuestion();
  }

  loadCurrentQuestion(){
    setState(() {
      clean();
      checkAnswerForCurrentQuestion();
      controller.text = answer ;
      if(currentQuestion == QuestionType.DATE_TYPE){
        List<String> d = answer.split("-");
        int year = int.parse(d[0]);
        int month = int.parse(d[1]);
        int day = int.parse(d[2]);
        selectedDate = DateTime(year,month,day);
      }
    });
  }

  void checkAnswerForCurrentQuestion() {
    Answer existAnswer = answers.firstWhere((a) => a.question.questionId == currentQuestion.questionId ,orElse: ()=>Answer.Empty());
    if(!existAnswer.isEmpty()){
      answer = existAnswer.answer ;
    }
    buttonEnabled = currentQuestion.required ? (answer == "" ? false : true) : true ;
  }

  void clean() {
    answer = "";
    checkedValue =  false ;
    firstCall = true ;
  }

  showProgress() {
    return SpinKitCircle(
      color: Colors.orangeAccent,
      size: 50.0,
    );
  }

  changeAnswerText(){
  }
  changeOptionsSelection(){
  }
  changeDate(){
  }

}