import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sayidati/Utilities/connection.dart';
import 'package:sayidati/Utilities/navigation.dart';
import 'package:sayidati/controllers/user_service.dart';
import 'package:sayidati/data/current_user.dart';
import 'package:sayidati/models/user.dart';
import 'package:sayidati/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {

  double width = 50 , height = 50 ;
  double maxWidthHeight = 100;

  String _connectionStatus = '';

  StreamSubscription<InternetConnectionStatus>? listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => animate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child : Center(
            child :
            Stack(
              children: [
            Center( child : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Container(
                      width: maxWidthHeight,
                      height: maxWidthHeight,
                      child: Column(
                        children: [
                          AnimatedContainer(
                              width: width,
                              height: height,
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOutCirc,
                              onEnd: (){
                                Connection connection = Connection();
                                connection.checkConnection(context, showNotConnected,next);
                              },
                              child : Image(
                                image:AssetImage("assets/images/ic_sayidati.png"),
                              )
                          ),
                        ],
                      ),
                    ),
                  Text(_connectionStatus,style: TextStyle(fontSize: 8),)
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("V 1.0"),
              ),
            )
            ],)
        ),
        ),
    );
  }

  animate() {
    setState(() {
      width = maxWidthHeight;
      height = maxWidthHeight ;
    });
  }

  showNotConnected() {
    setState(() {
      _connectionStatus = "S'il vous plait, vérifiez votre connexion internet.";
    });
  }

  next()async {
    String uid = await getUidFromLocalStorage() ;
    if(uid != ""){
      CurrentUser currentUser = CurrentUser();
      User user = await currentUser.loggedUser(uid);
      if(!user.isEmpty()){
        goToPage(context , Home());
        return;
      }
    }
    goToPage(context , Login());
  }

  Future<String> getUidFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid') ?? "";
    return uid;
  }
}
