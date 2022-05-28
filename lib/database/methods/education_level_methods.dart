import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/firebase_enums.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/objects/education_level.dart';

/// Methods to maintain EducationLevel object in database
mixin EducationLevelDatabaseMethods {
  /// Get all available education levels from database
  Future<List<EducationLevel>> getAvailableEducationLevel() async {
    final response = await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
        DatabaseObjectName.levels);

    if (response.status == FirebaseResponseStatus.failure) {
      return [];
    }
    return response.data.entries
        .map((levelEntry) => EducationLevel(levelEntry.key, levelEntry.value))
        .toList();
  }

  /// Add [levelsToAdd] levels to exited education levels.
  /// If level is already exist in database, it won't affect existed levels
  Future<void> addLevels(List<EducationLevel> levelsToAdd) async {
    Map<String, bool> levelValues = {
      for (var level in levelsToAdd) level.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        DatabaseObjectName.levels, levelValues);
  }
}
