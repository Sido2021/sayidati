import 'package:sayidati/controllers/questionnaire_service.dart';
import 'package:sayidati/controllers/user_service.dart';
import 'package:sayidati/models/user.dart';
 class CurrentUser {
   static User user = User("uid", "email", "name", "gender", "date", "imageUrl");

   Future<User> loggedUser(uid) async {
     UserService userService = UserService();
     User user = await userService.getUser(uid);
     user.answeredLastQuestionnaire = await userService.userAnsweredLastQuestionnaire(user.uid);
     CurrentUser.user = user ;
     return user;
   }
}
