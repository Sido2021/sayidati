import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/models/option.dart';

getSingleChoicesList(currentQuestion , Function changeOptionSelection , answer , enabled) {
  List<Option> options = currentQuestion.options ;
  Option selectedOption = Option.Empty();
  if(answer == "") currentQuestion.clearSelection();
  else {
    print(answer);
    int optionId = int.parse(answer);
    selectedOption = options.firstWhere((option) => option.optionId == optionId, orElse: () => Option.Empty());
    selectedOption.select();
  }

  return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: options.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            height: 50,
            child:
            RadioListTile(
              title: Text(options[index].title),
              value: options[index].optionId,
              groupValue: selectedOption.optionId,
              onChanged: (vl) {
                if(enabled)changeOptionSelection(options[index]);
              },
            ),
        );
      }
  );
}
