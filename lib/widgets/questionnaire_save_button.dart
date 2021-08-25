import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/utilities/variable.dart';

QuestionnaireSaveButton(Variable v, questionnaire, save) {
  bool buttonEnabled = v.isCreateMode() ? v.currentQuestion.required
      ? (v.currentQuestion.answer == "" ? false : true)
      : true : true;
  return Card(
      child: Directionality(
    textDirection: TextDirection.rtl,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary:
                    buttonEnabled ? Colors.orangeAccent : Colors.orange[100]),
            onPressed: () {
              if (buttonEnabled) {
                save();
              }
            },
            child: Text("احفظ")),
      ),
    ),
  ));
}
