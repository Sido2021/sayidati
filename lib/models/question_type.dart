class QuestionType {

  static int INPUT_TYPE = 1;
  static int MULTIPLE_CHOICE_TYPE = 2 ;
  static int SINGLE_CHOICE_TYPE = 3;
  static int DATE_TYPE = 4 ;

  String questionTypeId ;
  String questionTypeTitle ;

  QuestionType.fromJson(Map<String , dynamic> json)
  :
        questionTypeId = json['questionTypeId'],
        questionTypeTitle = json['questionTypeTitle']
  ;

  Map<String , dynamic> toJson() => {
    'questionTypeId' : questionTypeId ,
    'questionTypeTitle' : questionTypeTitle
  };

}