import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/models/option.dart';

getMultipleChoicesList(currentQuestion , changeAnswerText ,String answer , enabled ) {
  List<Option> options = currentQuestion.options ;
  print("anwser : "+answer);
  if(answer == "") currentQuestion.clearSelection();
  else {
    List<String> answers = answer.split(",");
    answers.forEach((element) {
      int optionId = int.parse(element);
      Option option = options.firstWhere((o) => o.optionId == optionId , orElse: () => Option.Empty());
      option.select();
    });
  }

  return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: enabled ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            height: 50,
            child:
            CheckboxListTile(
              title: Text(options[index].title),
              value: options[index].selected,
              onChanged: (newValue) {
                if(enabled){
                  options[index].selected = newValue!;
                  changeAnswerText(getAnswerText(options));
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