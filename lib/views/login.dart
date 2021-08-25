import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sayidati/Utilities/navigation.dart';
import 'package:sayidati/controllers/authentication_service.dart';
import 'package:sayidati/controllers/questionnaire_service.dart';
import 'package:sayidati/controllers/user_service.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/user.dart';
import 'package:sayidati/views/signup.dart';
import 'package:sayidati/widgets/background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool inProcessing = false;

  List<TextEditingController> textEditingController = [
    TextEditingController(),
    TextEditingController()
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Background(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "تسجيل الدخول",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                "assets/images/login.png",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "البريد الإلكتروني"),
                  onChanged: (value) {
                    textEditingController[0].text = value;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: "كلمة السر"),
                  onChanged: (value) {
                    textEditingController[1].text = value;
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              !inProcessing
                  ? loginButton(size.width)
                  : SpinKitCircle(
                      color: Colors.orangeAccent,
                      size: 50.0,
                    ),
              TextButton(
                  onPressed: () {
                    goTo(context , SignUp());
                  },
                  child: Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(color: Colors.orangeAccent),
                  )
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void login(email, password) async {
    setState(() {
      inProcessing = true;
    });
    AuthenticationService authenticationService = AuthenticationService();
    User user = await authenticationService.signin(email, password);

    if (!user.isEmpty()) {
      saveUidInLocalStorage(user.uid);
      UserService userService = UserService();
      user.answeredLastQuestionnaire = await userService.userAnsweredLastQuestionnaire(user.uid);
      CurrentUser.user = user;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      print("errooor ..................");
    }
    setState(() {
      inProcessing = false;
    });
  }

  loginButton(width) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // <-- Radius
            ),
            fixedSize: Size(width, 50.0)),
        onPressed: () {
          login(textEditingController[0].text, textEditingController[1].text);
        },
        child: Text("الدخول"));
  }

  Future<void> saveUidInLocalStorage(uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }



}
