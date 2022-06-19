import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/objects/tool.dart';

/// Methods to maintain Tool object in database
mixin ToolsDatabaseMethods {
  /// Return iterable of all tool objects from database
  Future<Iterable<Tool>> getAvailableTools() async {
    final response = await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
        DatabaseObjectName.tools);

    return response.data.entries
        .map((toolEntry) => Tool(toolEntry.key, toolEntry.value));
  }

  /// Add [toolsToAdd] to tools in database
  Future<void> addTools(List<Tool> toolsToAdd) async {
    Map<String, bool> toolValues = {
      for (var tool in toolsToAdd) tool.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        DatabaseObjectName.tools, toolValues);
  }
}
