import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/utilities/variable.dart';

QuestionnaireNavigationButtons(Variable v, questionnaire, next, previous) {
  bool buttonEnabled = v.currentQuestion.required
      ? (v.currentQuestion.answer == "" ? false : true)
      : true;
  return Card(
      child: Directionality(
    textDirection: TextDirection.rtl,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          !questionnaire.isFirstQuestion(v.currentQuestion)
              ? Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () {
                        previous();
                      },
                      child: Text("السابق")),
                )
              : SizedBox(),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: buttonEnabled
                        ? Colors.orangeAccent
                        : Colors.orange[100]),
                onPressed: () {
                  if (buttonEnabled) next();
                },
                child: Text("التالي")),
          ),
        ],
      ),
    ),
  ));
}
