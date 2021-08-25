import 'package:flutter/material.dart';

goToPage(context , page){
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

goTo(context , page){
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
}

goBack(context){
  Navigator.pop(context);
}