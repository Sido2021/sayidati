import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sayidati/controllers/answer_service.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/question_type.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/utilities/navigation.dart';
import 'package:sayidati/utilities/variable.dart';
import 'package:sayidati/widgets/finish_dialog.dart';
import 'package:sayidati/widgets/questionnaire_body.dart';
import 'package:sayidati/widgets/questionnaire_save_button.dart';
import 'package:sayidati/widgets/show_progress.dart';

class QuestionnaireReader extends StatefulWidget {
  Answer answer;
  Questionnaire questionnaire;

  QuestionnaireReader(this.answer, this.questionnaire);

  _QuestionnaireReaderState createState() => _QuestionnaireReaderState();
}

class _QuestionnaireReaderState extends State<QuestionnaireReader> {
  Variable v = Variable.reader();
  bool loadCompleted = false;
  bool sendingAnswers = false ;

  DateTime? selectedDate;

  List<Question> questions = [];

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
        child: loadCompleted && !sendingAnswers
            ? Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 40.0, bottom: 80.0),
                    child: Center(
                        child: Container(
                      width: size.width,
                      child: allQuestions(),
                    )),
                  ),
                  if (v.editable)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: QuestionnaireSaveButton(
                          v, widget.questionnaire, save),
                    ),
                  ElevatedButton(
                      onPressed: () {
                        activateEditMode();
                      },
                      child: Icon(Icons.edit)),
                ],
              )
            : showProgress(),
      ),
    );
  }

  void loadQuestionsAnswers() async {
    AnswerService answerService = AnswerService();
    questions = widget.questionnaire.getQuestionsCopies();
    List<Question> questionsAnswers = await answerService.getQuestionsAnswers(widget.answer);
    questions.forEach((question) {
      Question q = questionsAnswers.firstWhere((qa) => qa.questionId == question.questionId, orElse: () => Question.Empty());
      if(!q.isEmpty()){
        question.setAnswer(q.answer);
      }
      if(question.hasOptions()){
        question.options.forEach((option) {
          Question qs = questionsAnswers.firstWhere((qa) => qa.questionId == option.nextQuestion.questionId, orElse: () => Question.Empty());
          if(!qs.isEmpty()){
            option.nextQuestion.setAnswer(qs.answer);
          }
        });
      }
    });
    setState(() {
      loadCompleted = true;
    });
  }

  allQuestions() {
    List<Widget> widgets = [];
    getAllQuestions(widgets, questions[0]);
    return Column(
      children: widgets,
    );
  }

  changeAnswerText(String text, Question question) {
    setState(() {
      question.answer = text;
    });
  }

  changeOptionsSelection() {}

  changeDate() {}

  next() {}

  previous() {}

  saveAnswers() async {
    widget.answer.questionsAnswers.clear();
    fillNewAnswers();
    setState(() {
      sendingAnswers = true ;
    });
    AnswerService answerService = AnswerService();
    bool answersSent = await answerService.sendAnswers(widget.questionnaire.QID , widget.answer , "" ,"");

    if(answersSent){
      goBack(context);
    }else{
      setState(() {
        sendingAnswers = false ;
      });
    }

  }

  addAnswer() {}

  finishDialog() {}

  void activateEditMode() {
    setState(() {
      v.editable = true;
    });
  }

  void getAllQuestions(List<Widget> widgets, Question q) {
    v.currentQuestion = q;
    widgets.add(
        QuestionnaireBody(context, v, widget.questionnaire, changeAnswerText));
    if (v.currentQuestion.typeId == QuestionType.SINGLE_CHOICE_TYPE) {
      Question nextQ = v.currentQuestion.selectedOptions().first.nextQuestion;
      if (nextQ.isEmpty()) {
        nextQ = findQuestionByCurrentQuestion();
        if (!nextQ.isEmpty()) {
          getAllQuestions(widgets, nextQ);
        }
      } else {
        getAllQuestions(widgets, nextQ);
      }
    } else {
      Question nextQ = findQuestionByCurrentQuestion();
      if (!nextQ.isEmpty()) {
        getAllQuestions(widgets, nextQ);
      }
    }
  }

  Question findQuestionByCurrentQuestion() {
    String nq = v.currentQuestion.nextQuestionId;
    return questions.firstWhere((element) => element.questionId == nq,
        orElse: () => Question.Empty());
  }

  void save(){
    addAnswer();
    showFinishDialog(context,saveAnswers);
  }

  void fillNewAnswers() {
    questions.forEach((question) {
      widget.answer.questionsAnswers.add(question);
      if(question.hasOptions()){
        question.options.forEach((option) {
          if(option.selected){
            if(!option.nextQuestion.isEmpty())widget.answer.questionsAnswers.add(option.nextQuestion);
          }
        });
      }
    });
  }
}
