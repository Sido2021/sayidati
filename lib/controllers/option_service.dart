import 'dart:convert';

import 'package:http/http.dart' ;
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/models/option.dart';

class OptionService{
  Future<List<Option>> getOptions(int QuestionID) async {
    List<Option> options = [] ;
    final response = await post(Uri.parse(Constants.BASE_URL+'get_options.php'),
        body: <String, int>{
          'QuestionID': QuestionID
        }
    );

    if (response.statusCode == 200) {
      if(response.body != "0"){
        Iterable l = json.decode(response.body);
        options = List<Option>.from(l.map((model)=> Option.fromJson(model)));
      }
    }
    return options;
  }
}
