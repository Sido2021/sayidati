import 'package:flutter/material.dart';

questionInputBox(changeAnswerText,controller , enabled){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      enabled: enabled,
      controller: controller,
      style: TextStyle( decoration: TextDecoration.none , ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter your answer here'
      ),
      onChanged: (v){
        changeAnswerText(v);
      },
    ),
  );
}