import 'package:internet_connection_checker/internet_connection_checker.dart';

class Connection{
  checkConnection(context,showNotConnected,next) async{
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status){
        case InternetConnectionStatus.connected:
          next();
          break;
        case InternetConnectionStatus.disconnected:
          showNotConnected();
          break;
      }
    });
    return await InternetConnectionChecker().connectionStatus;
  }
}

