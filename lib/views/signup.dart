import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sayidati/Utilities/navigation.dart';
import 'package:sayidati/controllers/inscription_service.dart';
import 'package:sayidati/controllers/upload_service.dart';
import 'package:sayidati/models/user.dart';
import 'package:sayidati/views/login.dart';
import 'package:sayidati/widgets/background.dart';
import 'package:sayidati/widgets/date_box.dart';
import 'package:sayidati/widgets/done.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool inProcessing = false;
  final picker = ImagePicker();
  String status = '';
  String base64Image = "";
  File? image ;

  double width = 50 , height = 50 ;
  double maxWidthHeight = 100;
  String fileName = "";

  List<TextEditingController> textEditingController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  DateTime? selectedDate ;
  String dateOfBirth = "" ;
  String gender = "1" ;

  bool registered = false ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Background(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: !registered ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  registerView(size) ,
              ) : done(context,donePress),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void signup() async {
    setState(() {
      inProcessing = true;
    });
    bool upload = true ;
    if(image != null){
      fileName = image!.path.split('/').last;
      UploadService uploadService = UploadService();
      upload = await uploadService.uploadImage(base64Image,fileName);
    }
    if(upload){
      String name = textEditingController[0].text;
      String email = textEditingController[1].text;
      String password = textEditingController[2].text;
      User user = User(Uuid().v1(),email,name,gender,dateOfBirth,fileName);
      InscriptionService inscriptionService = InscriptionService();
      bool register = await inscriptionService.signUp(user,password);
      if(register){
        setState(() {
          inProcessing = false;
          registered = true;
        });
        return;
      }
      else{
        print("inscription failed !");
      }
    }
    else {
      print("Failed to upload image !");
    }
    setState(() {
      inProcessing = false;
    });
  }

  signUpButton(width) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // <-- Radius
            ),
            fixedSize: Size(width, 50.0)),
        onPressed: () {
          signup();
        },
        child: Text("Sign Up"));
  }



  chooseImage() async {
    XFile? pickedImage =await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedImage != null){
        image = File(pickedImage.path);
        base64Image = base64Encode(image!.readAsBytesSync());
      }

    });
  }

  getDefaultProfile() {
    return AssetImage("assets/images/ic_profile.jpg");
  }

  changeDate(pickedDate){
    if (pickedDate != null && pickedDate != selectedDate)
      setState(() {
        selectedDate = pickedDate;
        dateOfBirth = selectedDate!.year.toString()+"-"+selectedDate!.month.toString()+"-"+selectedDate!.day.toString();
      });
  }

  registerView(size) {
    return <Widget>[
      Text(
        "Sign Up",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: size.height * 0.03),
      Padding(
        padding: const EdgeInsets.only(top: 40.0 , bottom: 15.0),
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            child:
            GestureDetector(
              onTap: () =>chooseImage(),
              child: Center(
                child: CircleAvatar(
                  backgroundImage : image != null ? FileImage(image!)
                      : getDefaultProfile(),
                  radius: 50,
                ),
              ),
            )
            ,) ,
        ),
      ),
      SizedBox(height: size.height * 0.03),
      TextField(

        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: "Name"),
        onChanged: (value) {
          textEditingController[0].text = value;
        },
      ),
      SizedBox(height: size.height * 0.03),
      dateBox(context ,selectedDate , changeDate, true),
      SizedBox(height: size.height * 0.03),

      Center(
        child: GenderPickerWithImage(
          selectedGender: Gender.Male,
          selectedGenderTextStyle: TextStyle(
              color: Color(0xFF8b32a8), fontWeight: FontWeight.bold),
          unSelectedGenderTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.normal),
          onChanged: (Gender? g) {
            gender = (g!.index+1).toString() ;
            print(gender);
          },
          equallyAligned: true,
          femaleText: "",
          maleText: "",

          animationDuration: Duration(milliseconds: 300),
          padding: const EdgeInsets.all(0),
        ),
      ),
      SizedBox(height: size.height * 0.02),

      TextField(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: "Email"),
        onChanged: (value) {
          textEditingController[1].text = value;
        },
      ),
      SizedBox(height: size.height * 0.02),
      TextField(
        obscureText: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: "Password"),
        onChanged: (value) {
          textEditingController[2].text = value;
        },
      ),
      SizedBox(height: size.height * 0.02),
      !inProcessing
          ? signUpButton(size.width)
          : SpinKitCircle(
        color: Colors.orangeAccent,
        size: 50.0,
      ),
    ];
  }

  donePress(){
    Navigator.pop(context);
  }

}
