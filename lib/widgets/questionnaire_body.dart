import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question.dart';

QuestionnaireBody(questionnaire,currentQuestion,answerBox,next,buttonEnabled,previous){
  return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 200),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(currentQuestion.title,textAlign: TextAlign.center,),
                        SizedBox(
                          height: 50,
                          child:Text(
                            currentQuestion.required ?"*" : "" ,
                            style: TextStyle(
                              color: Colors.redAccent
                            ),
                          ),
                        )
                      ],
                    ),
                    answerBox()
                  ],
                )
            ),
        Stack(
                children: [
                  !questionnaire.isFirstQuestion(currentQuestion) ? Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                        onPressed: (){
                          previous();
                        },
                        child: Text("Previous")
                    ),
                  ) : SizedBox(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: buttonEnabled ? Colors.orangeAccent : Colors.orange[100]),
                      onPressed: (){
                        if(buttonEnabled) next();
                      },
                      child: Text("Next")
                    ),
                  ),

                ],
              ),
          ],
        ),
      )
  );
}
