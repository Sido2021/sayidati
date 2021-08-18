import 'package:flutter/material.dart';

goToPage(context , page){
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

goTo(context , page){
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
}

finish(context){
  Navigator.pop(context);
}