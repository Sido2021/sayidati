import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sayidati/controllers/answer_service.dart';
import 'package:sayidati/controllers/questionnaire_service.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/answer_details.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/question_type.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/utilities/constants.dart';
import 'package:sayidati/widgets/questionnaire_navigation_buttons.dart';
import 'package:sayidati/widgets/questionnaire_save_button.dart';
import '../utilities/variable.dart';
import 'package:sayidati/utilities/location.dart';
import 'package:sayidati/utilities/navigation.dart';
import 'package:sayidati/views/questionnaire_reader.dart';
import 'package:sayidati/widgets/done.dart';
import 'package:sayidati/widgets/finish_dialog.dart';
import 'package:sayidati/widgets/date_box.dart';
import 'package:sayidati/widgets/question_input_box.dart';
import 'package:sayidati/widgets/question_multiple_choices_list.dart';
import 'package:sayidati/widgets/question_single_choices_list.dart';
import 'package:sayidati/widgets/questionnaire_body.dart';
import 'package:sayidati/widgets/questionnaire_head.dart';
import 'package:sayidati/widgets/show_progress.dart';

class QuestionnaireActivity extends StatefulWidget {
  Questionnaire questionnaire ;
  QuestionnaireActivity(this.questionnaire);
  _QuestionnaireActivityState createState() => _QuestionnaireActivityState();
}

class _QuestionnaireActivityState extends State<QuestionnaireActivity> {

  String buttonText = "Next" ;
  bool completed = false;
  bool sendingAnswers = false ;
  bool checkedValue = false  ;
  bool doneStep = false ;
  bool questions_loaded = false ;
  Variable v = Variable();
  int operationMode = Constants.CREATE;

  List<Question> previousQuestions = [];

  List<Answer> userAnswers = [] ;
  AnswerService answerService = AnswerService();

  Answer currentAnswer = Answer.newAnswer();

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: (){
                      showUserQuestionnaireList();
                    },
                    child: Icon(Icons.list),
                ),
                 Container(
                  width: size.width,
                  height: size.height * 0.7,
                  child: Center(
                    child:questions_loaded && !sendingAnswers ? widget.questionnaire.questions.length > 0 ? showQuestionnaire() : Text("لا توجد أسئلة لهذا الإستبيان") : showProgress(),
                  )
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadQuestions() async {
    AnswerService answerService = AnswerService();
    await widget.questionnaire.loadQuestions();
    questions_loaded = true ;
    if(widget.questionnaire.questions.length > 0){
      userAnswers = await answerService.getCurrentUserAnswersByQID(widget.questionnaire);
      v.currentQuestion = widget.questionnaire.questions[0];
      loadCurrentQuestion();
    }
    else {
      setState(() {});
    }
  }

  loadCurrentQuestion(){
    setState(() {
      clean();
      //checkAnswerForCurrentQuestion();
    //v.currentQuestion.setAnswerToController();
    });
  }

  showQuestionnaire() {
    return Center(
      child: SizedBox.expand(
          child:
          Column(
            children: [
              QuestionnaireHead(widget.questionnaire),
              QuestionnaireBody(context,v,widget.questionnaire,changeAnswerText),
              QuestionnaireNavigationButtons(v,widget.questionnaire,next,previous),
              QuestionnaireSaveButton(v,widget.questionnaire,save),
            ],
          )
      ),
    ) ;
  }

  next(){
    setState(() {
      addAnswer();
      Question nextQuestion = Question.Empty();
      if(v.currentQuestion.typeId == QuestionType.SINGLE_CHOICE_TYPE){
        Question nextQ = v.currentQuestion.selectedOptions().first.nextQuestion ;
        if(nextQ.isEmpty()){
          nextQuestion = findQuestionByCurrentQuestion();}
        else {
          nextQuestion = nextQ;
        }
      }
      else {
        nextQuestion = findQuestionByCurrentQuestion();
       }

      if(!nextQuestion.isEmpty()){
        previousQuestions.add(v.currentQuestion);
        v.currentQuestion = nextQuestion;
       loadCurrentQuestion();
      }
      else {
        showFinishDialog(context,saveAnswers);
      }
    });
  }

  Question findQuestionByCurrentQuestion(){
    String nq = v.currentQuestion.nextQuestionId ;
    return widget.questionnaire.questions.firstWhere((element) => element.questionId == nq,orElse:()=> Question.Empty()) ;
  }

  previous(){
    setState(() {
      v.currentQuestion = previousQuestions.last;
      previousQuestions.remove(previousQuestions.last);
      clean();
      //checkAnswerForCurrentQuestion();
      //v.currentQuestion.setAnswerToController();
    });
  }

  /*void changeOptionsSelection(Option option) {
    setState(() {
      v.currentQuestion.clearSelection();
      option.select();
      changeAnswerText(option.optionId.toString());
      //checkLastQuestion();
    });
  }*/

  void addAnswer() {
    Question existQuestionAnswer = currentAnswer.questionsAnswers.firstWhere((q) => q.questionId == v.currentQuestion.questionId ,orElse: ()=>Question.Empty());
    if(existQuestionAnswer.isEmpty()){
      currentAnswer.questionsAnswers.add(v.currentQuestion);
    }
    else {
      existQuestionAnswer = v.currentQuestion;
    }
    //answerService.saveAnswersToLocal(answers,widget.questionnaire.QID);
  }

  changeAnswerText(String text,Question q){
    setState(() {
      v.currentQuestion.answer = text;
    });
  }

  void clean() {
    checkedValue =  false ;
  }

  saveAnswers() async {
    CurrentLocation currentLocation = CurrentLocation();
    bool enableLocationService = await currentLocation.enableService();
    if(enableLocationService){
      bool permissionGranted = await currentLocation.askForPermission();
      if(permissionGranted){
        setState(() {
          sendingAnswers = true ;
        });
        LocationData position = await currentLocation.getCurrentPosition();
        AnswerService answerService = AnswerService();
        bool answersSent = await answerService.sendAnswers(widget.questionnaire.QID , currentAnswer , position.latitude.toString() , position.longitude.toString());
        if(answersSent){
          goBack(context);
        }else{
          setState(() {
            sendingAnswers = false ;
          });
        }
      }
    }

  }

  /*void checkAnswerForCurrentQuestion() {
    Question existQuestionAnswer = currentAnswer.questionsAnswers.firstWhere((q) => q.questionId == v.currentQuestion.questionId ,orElse: ()=>Question.Empty());
    if(!existQuestionAnswer.isEmpty()){
      v.currentQuestion.answer = existQuestionAnswer.answer ;
    }
  }*/

  donePress(){
    setState(() {
      CurrentUser.user.answeredLastQuestionnaire = true ;
    });
  }

  showUserQuestionnaireList(){
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            content:  Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: userAnswers.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: TextButton(
                        onPressed: (){
                          goToPage(context, QuestionnaireReader(userAnswers[i],widget.questionnaire));
                        },
                        child: Text("الإجابة "+(i+1).toString()),
                    ),
                  );
                },
              ),
            )
        );
      },
    );
  }

  void save(){
    addAnswer();
    showFinishDialog(context,saveAnswers);
  }

}