import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart'; // Still used for Position model if needed by BLoC

class LocationService {
  Future<Position?> getCurrentPosition() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // 1. Check/Request Location Service (GPS) - Programmatically
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    // 2. Check/Request Permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permissionGranted == loc.PermissionStatus.deniedForever) {
      return Future.error('Location permissions are permanently denied, please enable them in settings.');
    }

    // 3. Get coordinates
    // We'll still use Geolocator to get the high-accuracy Position object expected by the rest of the app
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
