import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Placemark?> getLocationName(Position? position) async {
    if (position != null) {
      try {
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          return placemarks[1];
          // i changed the plaace mark index from [0] to [1]
        }
      } catch (e) {
        print("Error fetching location name");
      }

      return null;
    }
    return null;
  }
}
