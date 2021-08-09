import 'package:flutter/material.dart';
import 'package:sayidati/controllers/answer_service.dart';

Future<void> showFinishDialog(context ,saveAnswers) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Text('Do you want to send your answers ?'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
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