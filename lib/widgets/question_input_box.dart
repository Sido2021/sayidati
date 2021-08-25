import 'package:flutter/material.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/utilities/variable.dart';

questionInputBox(Variable v,changeAnswerText){
  Question question=  v.currentQuestion;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        enabled: v.editable,
        controller: v.currentQuestion.controller,
        style: TextStyle( decoration: TextDecoration.none , ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: v.editable ?'أدخل إجابتك هنا':""
        ),
        onChanged: (v){
          changeAnswerText(v,question);
        },
      ),
    ),
  );
}