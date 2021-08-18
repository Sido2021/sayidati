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

  String label = "";
  Question currentQuestion = Question.Empty();
  String buttonText = "Next" ;
  bool buttonEnabled = false ;
  bool firstCall = false ;
  bool completed = false;
  bool sendingAnswers = false ;
  String answer= "" ;
  bool checkedValue = false  ;
  bool doneStep = false ;
  bool questions_loaded = false ;
  DateTime? selectedDate ;

  List<AnswerDetails> answers = [] ;
  List<Question> previousQuestions = [];
  TextEditingController controller = TextEditingController();

  List<Answer> userAnswers = [] ;
  AnswerService answerService = AnswerService();

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
      currentQuestion = widget.questionnaire.questions[0];
      loadCurrentQuestion();
    }
    else {
      setState(() {});
    }
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

  showQuestionnaire() {
    return Center(
      child: SizedBox.expand(
          child:
          Column(
            children: [
              QuestionnaireHead(widget.questionnaire),
              QuestionnaireBody(widget.questionnaire,currentQuestion,answerBox,next,buttonEnabled,previous,false)
            ],
          )
      ),
    ) ;
  }

  answerBox(Question question) {
    switch(question.typeId){
      case 1 : return questionInputBox(changeAnswerText,controller,true);
      case 2 : return getMultipleChoicesList(currentQuestion,changeAnswerText , answer , true);
      case 3 : return getSingleChoicesList(currentQuestion , changeOptionsSelection ,answer,true);
      case 4 : return dateBox(context ,selectedDate , changeDate,true);
    }
  }

  next(){
    setState(() {
      previousQuestions.add(currentQuestion);
      addAnswer();
      String nextQ = "" ;
      print(currentQuestion.nextQuestionId);
      if(currentQuestion.typeId == QuestionType.SINGLE_CHOICE_TYPE){
        if(currentQuestion.selectedOption().nextQuestionId != "" && currentQuestion.selectedOption().nextQuestionId != "null"){
          nextQ = currentQuestion.selectedOption().nextQuestionId ;
        }
      }
      else {
        if(currentQuestion.nextQuestionId != "" && currentQuestion.nextQuestionId != "null"){
          nextQ = currentQuestion.nextQuestionId ;
        }
      }

      if(nextQ != ""){
        currentQuestion = widget.questionnaire.questions.firstWhere((element) => element.questionId == nextQ) ;
        loadCurrentQuestion();
      }
      else {
        showFinishDialog(context,saveAnswers);
      }
    });
  }

  previous(){
    setState(() {
      currentQuestion = previousQuestions.last;
      previousQuestions.remove(previousQuestions.last);
      clean();
      checkAnswerForCurrentQuestion();
      controller.text = answer ;
    });
  }

  void changeOptionsSelection(Option option) {
    setState(() {
      currentQuestion.clearSelection();
      option.select();
      changeAnswerText(option.optionId.toString());
      //checkLastQuestion();
    });
  }

  changeDate(pickedDate){
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        answer = selectedDate!.year.toString()+"-"+selectedDate!.month.toString()+"-"+selectedDate!.day.toString();
        buttonEnabled = currentQuestion.required ? (answer == "" ? false : true) : true ;
      });
    print(answer);
  }

  void addAnswer() {
    AnswerDetails existAnswer = answers.firstWhere((a) => a.question.questionId == currentQuestion.questionId ,orElse: ()=>AnswerDetails.Empty());
    if(existAnswer.isEmpty()){
      answers.add(AnswerDetails(currentQuestion , answer));
      print(currentQuestion.questionId+"......"+answer);
    }
    else {
      existAnswer = AnswerDetails(currentQuestion , answer);
    }
    //answerService.saveAnswersToLocal(answers,widget.questionnaire.QID);
  }

  changeAnswerText(text){
    setState(() {
      answer = text;
      buttonEnabled = currentQuestion.required ? (answer == "" ? false : true) : true ;
      firstCall = false ;
    });
  }

  void clean() {
    answer = "";
    checkedValue =  false ;
    firstCall = true ;
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
        bool answersSent = await answerService.sendAnswers(widget.questionnaire.QID , answers , position);
        print(answersSent);
        setState(() {
          /*sendingAnswers = false ;
          if(answersSent) setState(() {
            doneStep = true ;
            CurrentUser.user.answeredLastQuestionnaire = true;
            answerService.removeAnswersFromLocal(widget.questionnaire.QID);
          });
          else print("answers didn't send ...");*/
          finish(context);
        });
      }
    }

  }

  void checkAnswerForCurrentQuestion() {
    AnswerDetails existAnswer = answers.firstWhere((a) => a.question.questionId == currentQuestion.questionId ,orElse: ()=>AnswerDetails.Empty());
    if(!existAnswer.isEmpty()){
      answer = existAnswer.answer ;
    }
    buttonEnabled = currentQuestion.required ? (answer == "" ? false : true) : true ;
  }

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
}