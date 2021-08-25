import 'dart:convert';

import 'package:http/http.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/models/user.dart';

class InscriptionService{
  Future<bool> signUp(User user , password) async {
    String user_json = jsonEncode(user);
    final response = await post(Uri.parse(Constants.BASE_URL+'signup.php'),
        body: <String, String>{
          'user': user_json,
          'password' : password
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
