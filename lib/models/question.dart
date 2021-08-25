import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question_type.dart';

class Question {
  String questionId = "" ;
  int typeId = 0 ;
  String title = "" ;
  String nextQuestionId  = "";
  bool required = false;
  String answer = "" ;
  //Question nextQuestion = Question.Empty();

  TextEditingController controller = TextEditingController();

  List<Option> options = [] ;
  //Question(this.questionId, this.typeId, this.title , this.nextQuestionId,this.required);
  Question.Empty();
  Question.copy(Question question){
    this.questionId = question.questionId;
    this.typeId = question.typeId ;
    this.title = question.title ;
    this.nextQuestionId  = question.nextQuestionId;
    this.required = question.required;
    this.answer = question.answer ;

    this.controller = TextEditingController();
    this.controller.text = question.answer;

    this.options = [] ;
    question.options.forEach((option) {
      this.options.add(Option.copy(option));
    });
  }

  Question.fromJson(Map<String , dynamic> json)
      : questionId = json['QuestionID'],
        typeId = int.parse(json['QuestionTypeId']),
        title = json['Title'],
        nextQuestionId = json['NextQuestionID'].toString(),
        required = json['Required'] =="0" ? false : true,
        answer = json['Answer'].toString() != "null" ? json['Answer'] : ""
  {
    if(json['Options'] !=null)loadOptions(json['Options']);
    controller.text = answer;
  }

  Map<String , dynamic > toJson() => {
    'QuestionID' : questionId ,
    'TypeId' : typeId ,
    'Title' : title ,
    'NextQuestionId' : nextQuestionId,
    'Required' : required,
    'Answer' : answer
  };

  loadOptions(optionsJson){
    Iterable l = optionsJson;
    options = List<Option>.from(l.map((model)=> Option.fromJson(model)));
  }

  clearSelection(){
    options.forEach((option) {option.deselect();});
  }

  List<Option> selectedOptions(){
    if(typeId != QuestionType.SINGLE_CHOICE_TYPE){
      return [Option.Empty()] ;
    }
    else {
      List<Option> listOptions  = options.where((option) => option.selected).toList();
      return listOptions.length>0 ? listOptions : [Option.Empty()] ;
    }
  }

  bool isEmpty()=> questionId == "" ;

  void setAnswer(answer) {
    this.answer = answer;
    controller.text = answer;
  }

  bool hasAnswer(){
    return answer != "" ;
  }

  bool hasOptions(){
    return options.length > 0;
  }
}