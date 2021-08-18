import 'package:flutter/material.dart';
import 'package:sayidati/controllers/answer_service.dart';

Future<void> showFinishDialog(context ,saveAnswers) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Text('هل تريد حقا إرسال أجوبتك؟'),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('لا'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('نعم'),
            onPressed: () {
              Navigator.of(context).pop();
              saveAnswers();
            },
          ),
        ],
      );
    },
  );
}