
import 'package:flutter/material.dart';

QuestionnaireHead(questionnaire){
  return Card(
      child: Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 20),
          child: Text(questionnaire.label,textAlign: TextAlign.center,)
      )
  );
}