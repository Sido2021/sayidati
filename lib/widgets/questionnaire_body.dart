import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/utilities/variable.dart';

import 'question_input_box.dart';
import 'date_box.dart';
import 'question_multiple_choices_list.dart';
import 'question_single_choices_list.dart';

QuestionnaireBody(BuildContext context ,Variable v,questionnaire,changeAnswerText){
 return Card(
   color: v.isCreateMode() ? Colors.white : (v.currentQuestion.hasAnswer() ? Colors.green[100]:Colors.red[100]) ,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      getQuestionHead(v),
                      getAnswerBox(context,v,changeAnswerText)
                    ],
                  )
              ),
            ],
          ),
        ),
      )
  );
}

getQuestionHead(Variable v){
  return Row(
    children: [
      Text(v.currentQuestion.title,textAlign: TextAlign.center,),
      SizedBox(
        height: 50,
        child:Center(
          child: Text(
            v.editable ? v.currentQuestion.required ?" *" : "" : "",
            style: TextStyle(
                color: Colors.redAccent
            ),
          ),
        ),
      ),
    ],
  );
}


getAnswerBox(BuildContext context ,Variable v,changeAnswerText) {
  int type = v.currentQuestion.typeId;
  switch(type){
    case 1 : return questionInputBox(v,changeAnswerText);
    case 2 : return getMultipleChoicesList(v,changeAnswerText);
    case 3 : return getSingleChoicesList(v,changeAnswerText);
    case 4 : return dateBox(context ,v,changeAnswerText);
  }
}
