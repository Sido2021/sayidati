import 'package:flutter/cupertino.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/utilities/constants.dart';

class Variable{
  Question currentQuestion = Question.Empty();
  bool editable = true ;
  //int index = 0 ;
  int mode = Constants.CREATE;

  Variable();
  Variable.reader(){
    this.editable = false;
    this.mode = Constants.VIEW_MODIFY;
  }

  bool isCreateMode() {
    return mode == Constants.CREATE;
  }
}