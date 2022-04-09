import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/education_level.dart';

mixin EducationLevelDatabaseMethods on IDatabase {
  Future<Iterable<EducationLevel>> getAvailableEducationLevel() async {
    DBValues<bool> levelValues =
        await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
            fbReference!, DatabaseObjectName.levels);

    return levelValues.entries
        .map((levelEntry) => EducationLevel(levelEntry.key, levelEntry.value));
  }

  Future<void> addLevels(List<EducationLevel> levelsToAdd) async {
    Map<String, bool> levelValues = {
      for (var level in levelsToAdd) level.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        fbReference!, DatabaseObjectName.levels, levelValues);
  }
}
