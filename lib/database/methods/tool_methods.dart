import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/tool.dart';

mixin ToolsDatabaseMethods {
  Future<Iterable<Tool>> getAvailableTools() async {
    DBValues<bool> toolValues =
        await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
            DatabaseObjectName.tools);

    return toolValues.entries
        .map((toolEntry) => Tool(toolEntry.key, toolEntry.value));
  }

  Future<void> addTools(List<Tool> toolsToAdd) async {
    Map<String, bool> toolValues = {
      for (var tool in toolsToAdd) tool.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        DatabaseObjectName.tools, toolValues);
  }
}
