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
import 'package:sayidati/models/answer_details.dart';
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
import 'package:sayidati/widgets/show_progress.dart';

class QuestionnaireReader extends StatefulWidget {
  Answer answer;
  Questionnaire questionnaire ;
  QuestionnaireReader(this.answer,this.questionnaire);
  _QuestionnaireReaderState createState() => _QuestionnaireReaderState();
}

class _QuestionnaireReaderState extends State<QuestionnaireReader> {

  Question currentQuestion = Question.Empty();
  bool buttonEnabled = false ;
  String answer= "" ;
  bool loadCompleted = false ;
  DateTime? selectedDate ;

  List<AnswerDetails> answerDetailsList = [] ;
  List<TextEditingController> controllers = [];

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
                      height: size.height ,
                      child: loadCompleted ? allQuestions() : showProgress(),
                    )
                  ]
              ),
          ),
        ),
      ),
    );
  }

  void loadQuestionsAnswers() async {
    AnswerService answerService = AnswerService();
    answerDetailsList = await answerService.getAnswerDetailsList(widget.answer);
    setState(() {
      loadCompleted=true;
    });
  }

  answerBox(Question question) {
    switch(question.typeId){
      case 1 : return questionInputBox(changeAnswerText,controllers.last,false);
      case 2 : return getMultipleChoicesList(currentQuestion,changeAnswerText , answer , false );
      case 3 : return getSingleChoicesList(currentQuestion , changeOptionsSelection ,answer,false);
      case 4 : {
        List<String> d = answer.split("-");
        int year = int.parse(d[0]);
        int month = int.parse(d[1]);
        int day = int.parse(d[2]);
        DateTime date  = DateTime(year,month,day);
        return dateBox(context ,date , changeDate,false);
      }
    }
  }

  allQuestions(){
    List<Widget> widgets = [];
    answerDetailsList.forEach((answerDetails) {
      currentQuestion = answerDetails.question;
      answer = answerDetails.answer;
      if(currentQuestion.typeId == 1){
        controllers.add(TextEditingController());
        controllers.last.text = answer;
      }
      widgets.add(QuestionnaireBody(widget.questionnaire,currentQuestion,answerBox,next,buttonEnabled,previous,true));
    });
    return SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            children: widgets,
          ),
        )
    );
  }

  changeAnswerText(){}
  changeOptionsSelection(){}
  changeDate(){}
  next(){}
  previous(){}
}