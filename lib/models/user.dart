class User {

  String uid = "";
  String email = "";
  String name= "" ;
  String gender = "" ;
  String dateOfBirth = "";
  String? imageUrl = "";
  bool answeredLastQuestionnaire = false ;

  User(this.uid, this.email, this.name, this.gender, this.dateOfBirth,
      this.imageUrl);
  User.empty();

  User.fromJson(Map<String, dynamic> json)
      : uid = json['UID'],
        email = json['Email'],
        name = json['Name'],
        gender = json['Gender'],
        dateOfBirth = json['DateOfBirth'],
        imageUrl = json['ImageUrl']
  ;

  Map<String, dynamic> toJson() => {
    'UID': uid,
    'Email' : email,
    'Name': name,
    'Gender': gender,
    'DateOfBirth': dateOfBirth,
    'ImageUrl': imageUrl,
  };

  isEmpty() => uid =="";

}
