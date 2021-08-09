import 'package:flutter/material.dart';

dateBox(context ,DateTime? selectedDate, changeDate,enabled) {
  if(selectedDate == null){
    selectedDate = DateTime.now();
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
          if(enabled)_selectDate(context,selectedDate, changeDate );
        },
        child: Text(
          selectedDate == null ?"--/--/----"
           : selectedDate.day.toString()+"/"+ selectedDate.month.toString() +"/"+selectedDate.year.toString() ,
          style: TextStyle(color: Colors.orangeAccent),
        )
    ),
  );

}

Future<void> _selectDate(BuildContext context ,selectedDate, changeDate ) async {

  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
  );

  changeDate(picked);

}