import 'dart:convert';

import 'package:http/http.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/models/user.dart';

class UserService{
  Future<User> getUser(uid) async {
    final response = await post(Uri.parse(Constants.BASE_URL+'get_user.php'),
        body: <String, String>{
          'uid': uid
        }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode((response.body));
      if (data["res"] == "1") {
        return User.fromJson(data);
      }
    }
    return User.empty();
  }

  Future<bool> userAnsweredLastQuestionnaire(uid) async {
    final response = await post(Uri.parse(Constants.BASE_URL+"user_answered_last_questionnaire.php"),
        body: <String, String>{
          'uid': uid,
        }
    );

    if (response.statusCode == 200) {
      if (response.body == "1") {
        return true;
      }
    }
    return false;
  }
}
