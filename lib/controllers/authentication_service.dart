import 'dart:convert';

import 'package:http/http.dart';
import 'package:sayidati/Utilities/constants.dart';
import 'package:sayidati/models/user.dart';

class AuthenticationService{
  Future<User> signin(email,password) async {
    final response = await post(Uri.parse(Constants.BASE_URL+'login.php'),
        body: <String, String>{
          'email': email,
          'password': password
        }
    );

    if (response.statusCode == 200) {
      Map<String , dynamic> data = jsonDecode(response.body);
      if(data["res"] == "1"){
        return User.fromJson(data);
      }
    }
    return User.empty() ;
  }
}
