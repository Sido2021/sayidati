import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sayidati/controllers/questionnaire_service.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/questionnaire.dart';
import 'package:sayidati/utilities/constants.dart';
import 'package:sayidati/utilities/navigation.dart';
import 'package:sayidati/views/questionnaire_activity.dart';
import 'package:sayidati/views/questionnaire_reader.dart';
import 'package:sayidati/widgets/show_progress.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Questionnaire> questionnaires = [] ;
  bool questionnaires_loaded = false ;

  @override
  void initState() {
    super.initState();
    loadQuestionnaire();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Center(
                child: Column(
                  children: [
                    profile(size),
                    questionnaires_loaded ? questionnaireList() : showProgress(),
                    ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  void loadQuestionnaire() async {
    QuestionnaireService questionnaireService = QuestionnaireService();
    questionnaires = await questionnaireService.getAllQuestionnaires();
    questionnaires_loaded = true ;
    setState(() {
    });
  }

  profileImage() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: Center(
          child : CircleAvatar(
              radius: 100,
              child: ClipOval(
                child: CurrentUser.user.imageUrl != "" ? Image.network(Constants.BASE_URL_IMAGES+CurrentUser.user.imageUrl!, height: 100, width: 100, fit: BoxFit.cover,)
                    : getDefaultProfile(),
              )
          ),
        ) ,
      ),
    );
  }

  getDefaultProfile() {
    return Image.asset("assets/images/ic_profile.jpg",height: 100, width: 100, fit: BoxFit.cover,);
  }

  profile(size) {
    return
      Container(
        height: size.height * 0.1,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black45,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child:
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImage(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(CurrentUser.user.name),
            ),
          ],
        ),
      );
  }

  questionnaireList(){
    return Container(
      padding: EdgeInsets.all(8.0),
      width: double.maxFinite,
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: questionnaires.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.amberAccent,
              child: Center(
                  child: SizedBox.expand(
                    child: TextButton(
                      onPressed: (){
                        goTo(context, QuestionnaireActivity(questionnaires[index]));
                      },
                      child: Text(
                          questionnaires[index].label,
                          style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
              ),
            );
          }
      ),
    );
  }
}