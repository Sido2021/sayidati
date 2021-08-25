import 'package:flutter/material.dart';
import 'package:sayidati/models/question.dart';
import 'package:sayidati/utilities/variable.dart';

dateBox(context ,Variable v , changeAnswerText) {
  Question question =  v.currentQuestion;
  String stringDate = "--/--/----" ;
  DateTime date = DateTime.now();
  if(v.currentQuestion.hasAnswer()){
    List<String> yearMonthDay = v.currentQuestion.answer.split("-");
    int year = int.parse(yearMonthDay[0]);
    int month = int.parse(yearMonthDay[1]);
    int day = int.parse(yearMonthDay[2]);
    stringDate = year.toString()+"/"+month.toString()+"/"+day.toString();
    date = DateTime(
        int.parse(yearMonthDay[0]), int.parse(yearMonthDay[1]), int.parse(yearMonthDay[2]));
  }
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black45,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20))
    ),
    child: TextButton(
        onPressed: () {
          if(v.editable)_selectDate(context,date, changeAnswerText ,question);
        },
        child: Text(stringDate,
          style: TextStyle(color: Colors.orangeAccent),
        )
    ),
  );

}

Future<void> _selectDate(BuildContext context ,DateTime date , changeAnswerText ,Question question) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null ){
      String d = pickedDate.year.toString() + "-" +
          pickedDate.month.toString() + "-" + pickedDate.day.toString();
      changeAnswerText(d,question);
    }
}