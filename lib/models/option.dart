import 'package:sayidati/models/question.dart';

class Option {
  int optionId = 0 ;
  String title = "" ;
  String nextQuestionId = "";
  bool selected = false ;
  Question nextQuestion = Question.Empty();

  Option(this.optionId, this.title, this.nextQuestionId);
  Option.Empty();
  Option.copy(Option option){
    this.optionId = option.optionId ;
    this.title = option.title ;
    this.nextQuestionId = option.nextQuestionId;
    this.selected = option.selected;
    this.nextQuestion = Question.copy(option.nextQuestion);
  }

  Option.fromJson(Map<String , dynamic> json)
  :
        optionId = int.parse(json['OptionID']),
        title = json['OptionTitle'] ,
        nextQuestionId = json['NextQuestionID'].toString()
      ;

  Map<String , dynamic> toJson() => {
    'optionId' : optionId ,
    'title' : title ,
    'nextQuestionId' : nextQuestionId
  };

  select(){selected = true;}
  deselect(){selected = false;}

  bool hasNextQuestion(){
    return nextQuestionId != "" && nextQuestionId != "null" ;
  }
}