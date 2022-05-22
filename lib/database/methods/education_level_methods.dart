import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/education_level.dart';

/// Methods to maintain EducationLevel object in database
mixin EducationLevelDatabaseMethods on IDatabase {
  /// Get all available education levels from database
  Future<Iterable<EducationLevel>> getAvailableEducationLevel() async {
    DBValues<bool> levelValues =
        await firebaseAdapter.getAvailableObjects(
            DatabaseObjectName.levels);

    return levelValues.entries
        .map((levelEntry) => EducationLevel(levelEntry.key, levelEntry.value));
  }

  /// Add [levelsToAdd] levels to exited education levels.
  /// If level is already exist in database, it won't affect existed levels
  Future<void> addLevels(List<EducationLevel> levelsToAdd) async {
    Map<String, bool> levelValues = {
      for (var level in levelsToAdd) level.name: false
    };
    await firebaseAdapter.addObjects(
        DatabaseObjectName.levels, levelValues);
  }
}
