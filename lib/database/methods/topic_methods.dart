import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/objects/topic.dart';

/// Methods to maintain Topic object in database
mixin TopicDatabaseMethods {
  /// Return iterable of all topics objects from database
  Future<Iterable<Topic>> getAvailableTopics() async {
    final response = await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
        DatabaseObjectName.topics);

    return response.data.entries
        .map((topicEntry) => Topic(topicEntry.key, topicEntry.value));
  }

  /// Add [topicsToAdd] to tools in database
  Future<void> addTopics(List<Topic> topicsToAdd) async {
    Map<String, bool> topicValues = {
      for (var topic in topicsToAdd) topic.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        DatabaseObjectName.topics, topicValues);
  }
}
