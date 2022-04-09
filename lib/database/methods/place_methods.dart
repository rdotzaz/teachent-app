import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/place.dart';

mixin PlaceDatabaseMethods on IDatabase {
  Future<Iterable<Place>> getAvailablePlaces() async {
    DBValues<bool> placeValues =
        await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
            fbReference!, DatabaseObjectName.places);

    return placeValues.entries
        .map((placeEntry) => Place(placeEntry.key, placeEntry.value));
  }

  Future<void> addPlaces(List<Place> placesToAdd) async {
    Map<String, bool> placeValues = {
      for (var place in placesToAdd) place.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        fbReference!, DatabaseObjectName.places, placeValues);
  }
}
