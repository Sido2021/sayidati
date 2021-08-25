import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/utilities/variable.dart';

getSingleChoicesList(Variable v , changeAnswerText) {
  Question question =  v.currentQuestion;
  List<Option> options = v.currentQuestion.options ;
  Option selectedOption = Option.Empty();
  if(!v.currentQuestion.hasAnswer()) v.currentQuestion.clearSelection();
  else {
    int optionId = int.parse(v.currentQuestion.answer);
    selectedOption = options.firstWhere((option) => option.optionId == optionId, orElse: () => Option.Empty());
    v.currentQuestion.clearSelection();
    selectedOption.select();
  }

  return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics() ,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: options.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
            height: 50,
            child:
            RadioListTile(
              title: Text(options[i].title),
              value: options[i].optionId,
              groupValue: selectedOption.optionId,
              onChanged: (vl) {
                if(v.editable)changeAnswerText(options[i].optionId.toString(),question);
              },
            ),
        );
      }
  );
}
