import 'package:http/http.dart';
import 'package:sayidati/Utilities/constants.dart';

class UploadService{
  Future<bool> uploadImage(image ,name) async {
    final response = await post(Uri.parse(Constants.BASE_URL_IMAGES+'upload_image.php'),
        body: <String, String>{
          'image': image ,
          'name' : name
        }
    );

    if (response.statusCode == 200) {
      if (response.body == "1") {
        return true;
      }
    }
    return false;
  }
}