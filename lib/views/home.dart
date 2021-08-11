import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:location/location.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/Utilities/location.dart';
import 'package:sayidati/Utilities/navigation.dart';
import 'package:sayidati/controllers/answer_service.dart';
import 'package:sayidati/controllers/questionnaire_service.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/models/question_type.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/views/questionnaire_reader.dart';
import 'package:sayidati/widgets/done.dart';
import 'package:sayidati/widgets/finish_dialog.dart';
import 'package:sayidati/widgets/date_box.dart';
import 'package:sayidati/widgets/question_input_box.dart';
import 'package:sayidati/widgets/question_multiple_choices_list.dart';
import 'package:sayidati/widgets/question_single_choices_list.dart';
import 'package:sayidati/widgets/questionnaire_body.dart';
import 'package:sayidati/widgets/questionnaire_head.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String label = "";
  Questionnaire questionnaire = Questionnaire(0, "", "");
  Question currentQuestion = Question.Empty();
  String buttonText = "Next" ;
  bool buttonEnabled = false ;
  bool firstCall = false ;
  bool completed = false;
  bool sendingAnswers = false ;
  String answer= "" ;
  bool checkedValue = false  ;
  bool doneStep = false ;
  DateTime? selectedDate ;

  List<Answer> answers = [] ;
  List<Question> previousQuestions = [];
  TextEditingController controller = TextEditingController();

  List<Questionnaire> userQuestionnaires = [] ;
  AnswerService answerService = AnswerService();
  @override
  void initState() {
    super.initState();
    loadQuestionnaire();
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
                  profile(size),
                  !CurrentUser.user.answeredLastQuestionnaire ? Container(
                    width: size.width,
                    height: size.height * 0.7,
                    child: questionnaire.QID != 0 && !sendingAnswers ? doneStep ? done(context,donePress) : showQuestionnaire() : showProgress(),
                  ): Text("You answered last questionnaire !"),
                  ],
              ),
          ),
        ),
      ),
    );
  }

  void loadQuestionnaire() async {
    QuestionnaireService questionnaireService = QuestionnaireService();
    Questionnaire q = await questionnaireService.getQuestionnaire();
    await q.loadQuestions();
    userQuestionnaires = await questionnaireService.getUserQuestionnaires();
    answers = await answerService.getAnswersFromLocal(questionnaire);
    questionnaire = q;
    currentQuestion = q.questions[0];

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

  showQuestionnaire() {
   return Center(
        child: SizedBox.expand(
          child:
              Column(
                children: [
                  QuestionnaireHead(questionnaire),
                  QuestionnaireBody(questionnaire,currentQuestion,answerBox,next,buttonEnabled,previous)
                ],
              )
          ),
    ) ;
  }

  answerBox() {
    switch(currentQuestion.typeId){
      case 1 : return questionInputBox(changeAnswerText,controller,true);
      case 2 : return getMultipleChoicesList(currentQuestion,changeAnswerText , answer , true);
      case 3 : return getSingleChoicesList(currentQuestion , changeOptionsSelection ,answer,true );
      case 4 : return dateBox(context ,selectedDate , changeDate,true);
    }
  }

  next(){
    setState(() {
      previousQuestions.add(currentQuestion);
      addAnswer();
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
        currentQuestion = questionnaire.questions.firstWhere((element) => element.questionId == nextQ) ;
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
  }

  void addAnswer() {
    Answer existAnswer = answers.firstWhere((a) => a.question.questionId == currentQuestion.questionId ,orElse: ()=>Answer.Empty());
    if(existAnswer.isEmpty()){
      answers.add(Answer(CurrentUser.user, currentQuestion , answer));
    }
    else {
      existAnswer = Answer(CurrentUser.user, currentQuestion , answer);
    }
    answerService.saveAnswersToLocal(answers);
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

  showProgress() {
    return SpinKitCircle(
      color: Colors.orangeAccent,
      size: 50.0,
    );
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
        bool answersSent = await answerService.sendAnswers(questionnaire.QID , answers , position);
        print(answersSent);
        setState(() {
          sendingAnswers = false ;
          if(answersSent) setState(() {
            doneStep = true ;
            CurrentUser.user.answeredLastQuestionnaire = true;
          });
          else print("answers didn't send ...");
        });
      }
    }

  }

  void checkAnswerForCurrentQuestion() {
    Answer existAnswer = answers.firstWhere((a) => a.question.questionId == currentQuestion.questionId ,orElse: ()=>Answer.Empty());
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

  profileImage() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: Center(
          child : CircleAvatar(
              radius: 100,
              child: ClipOval(
                child: CurrentUser.user.imageUrl != "" ? Image.network(Constants.BASE_URL_IMAGES+CurrentUser.user.imageUrl!, height: 100, width: 100, fit: BoxFit.cover,)
                    : getDefaultProfile(),
              )
          ),
        ) ,
      ),
    );
  }

  getDefaultProfile() {
    return Image.asset("assets/images/ic_profile.jpg",height: 100, width: 100, fit: BoxFit.cover,);
  }

  profile(size) {
    return
      Container(
        height: size.height * 0.1,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black45,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImage(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(CurrentUser.user.name),
            ),
            ElevatedButton(onPressed: (){
              showUserQuestionnaireList();
            }, child: Icon(Icons.list))
          ],
        ),
      );
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
                  itemCount: userQuestionnaires.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: TextButton(
                        onPressed: (){
                          goToPage(context, QuestionnaireReader(userQuestionnaires[i]));
                        },
                          child: Text(userQuestionnaires[i].label)
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