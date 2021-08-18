import 'package:sayidati/models/question.dart';

class Option {
  int optionId = 0 ;
  String title = "" ;
  String nextQuestionId = "";
  bool selected = false ;

  Option(this.optionId, this.title, this.nextQuestionId);
  Option.Empty();

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
}