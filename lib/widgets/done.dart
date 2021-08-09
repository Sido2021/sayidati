import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

done(context,@required onPress) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children : <Widget>[
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image(
        image: AssetImage("assets/images/ic_done.png"),
        width: 50,
        height: 50,
      ),
    ),
    Text(
      "Done !",
      style: TextStyle(fontSize: 8),
    ),
    ElevatedButton(onPressed: () {
      onPress();
    }, child: Text("OK"))
  ]
  );
}
