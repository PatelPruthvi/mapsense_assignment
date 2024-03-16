import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<Position> getCurrentPosition();
  Future<LocationPermission> requestPermission();
}

class GeolocatorService implements LocationService {
  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  @override
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }
}
