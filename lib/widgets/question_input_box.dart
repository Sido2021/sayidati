import 'package:flutter/material.dart';

questionInputBox(changeAnswerText,controller , enabled){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        enabled: enabled,
        controller: controller,
        style: TextStyle( decoration: TextDecoration.none , ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'أدخل إجابتك هنا'
        ),
        onChanged: (v){
          changeAnswerText(v);
        },
      ),
    ),
  );
}