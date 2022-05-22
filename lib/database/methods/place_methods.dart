import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/place.dart';

/// Methods to maintain Place object in database
mixin PlaceDatabaseMethods on IDatabase {
  /// Get all available places from database
  Future<Iterable<Place>> getAvailablePlaces() async {
    DBValues<bool> placeValues =
        await firebaseAdapter.getAvailableObjects(
            DatabaseObjectName.places);

    return placeValues.entries
        .map((placeEntry) => Place(placeEntry.key, placeEntry.value));
  }

  /// Add place to database
  Future<void> addPlaces(List<Place> placesToAdd) async {
    Map<String, bool> placeValues = {
      for (var place in placesToAdd) place.name: false
    };
    await firebaseAdapter.addObjects(
        DatabaseObjectName.places, placeValues);
  }
}
