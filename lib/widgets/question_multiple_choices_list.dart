import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/utilities/variable.dart';

getMultipleChoicesList(Variable v , changeAnswerText ) {
  Question question =  v.currentQuestion;
  List<Option> options = v.currentQuestion.options ;
  if(!v.currentQuestion.hasAnswer()) v.currentQuestion.clearSelection();
  else {
    List<String> answers = v.currentQuestion.answer.split(",");
    answers.forEach((element) {
      int optionId = int.parse(element);
      Option option = options.firstWhere((o) => o.optionId == optionId , orElse: () => Option.Empty());
      option.select();
    });
  }

  return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: options.length,
      itemBuilder: (BuildContext context, int i) {
        return Container(
            height: 50,
            child:
            CheckboxListTile(
              title: Text(options[i].title),
              value: options[i].selected,
              onChanged: (newValue) {
                if(v.editable){
                  options[i].selected = newValue!;
                  changeAnswerText(getAnswerText(options),question);
                }
              },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            )
        );
      }
  );
}

String getAnswerText(List<Option> options) {
  String answer = "";
  List<Option> selected_options = options.where((element) => element.selected).toList();
  for(int i = 0 ; i<selected_options.length;i++){
    answer += selected_options[i].optionId.toString();
    if(i<selected_options.length-1) answer+=",";
  }
  return answer ;
}