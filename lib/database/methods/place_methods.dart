import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/objects/place.dart';

/// Methods to maintain Place object in database
mixin PlaceDatabaseMethods {
  /// Get all available places from database
  Future<Iterable<Place>> getAvailablePlaces() async {
    final response = await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
        DatabaseObjectName.places);

    return response.data.entries
        .map((placeEntry) => Place(placeEntry.key, placeEntry.value));
  }

  /// Add place to database
  Future<void> addPlaces(List<Place> placesToAdd) async {
    Map<String, bool> placeValues = {
      for (var place in placesToAdd) place.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        DatabaseObjectName.places, placeValues);
  }
}
