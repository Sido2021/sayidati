import 'package:sayidati/models/answer.dart';
import 'package:sayidati/models/option.dart';
import 'package:sayidati/models/question_type.dart';

class Question {
  int questionId = 0 ;
  int typeId = 0 ;
  String title = "" ;
  int nextQuestionId  = 0;
  bool required = false;

  List<Option> options = [] ;
  Question(this.questionId, this.typeId, this.title , this.nextQuestionId,this.required);
  Question.Empty();
  Question.fromID(this.questionId);

  Question.fromJson(Map<String , dynamic> json)
      : questionId = int.parse(json['QuestionID']),
        typeId = int.parse(json['QuestionTypeID']),
        title = json['Title'],
        nextQuestionId = int.parse(json['NextQuestionID']),
        required = json['Required'] =="0" ? false : true
  {
    if(json['options'] !=null)loadOptions(json['options']);
  }

  Map<String , dynamic > toJson() => {
    'questionId' : questionId ,
    'typeId' : typeId ,
    'title' : title ,
    'nextQuestionId' : nextQuestionId,
    'required' : required
  };

  loadOptions(optionsJson){
    Iterable l = optionsJson;
    options = List<Option>.from(l.map((model)=> Option.fromJson(model)));
  }

  clearSelection(){
    options.forEach((option) {option.deselect();});
  }

  Option selectedOption(){
    if(typeId != QuestionType.SINGLE_CHOICE_TYPE){
      return Option(0, "", 0) ;
    }
    else {
      return options.firstWhere((element) => element.selected);
    }
  }

  bool isEmpty()=> questionId == 0 ;
}