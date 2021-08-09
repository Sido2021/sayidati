import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class CurrentLocation{
  Future<bool> enableService() async {
    Location location = Location();
    bool _serviceEnabled;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false ;
      }
    }
    return true ;
  }
  Future<bool> askForPermission() async {
    Location location = Location();
    PermissionStatus _permissionGranted;

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false ;
      }
    }
    return true ;
  }
  Future<LocationData> getCurrentPosition() async {
    Location location = new Location();
    LocationData _locationData;

    _locationData = await location.getLocation();

    return _locationData ;
  }
}
