import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/model/objects/topic.dart';

mixin TopicDatabaseMethods on IDatabase {
  Future<Iterable<Topic>> getAvailableTopics() async {
    DBValues<bool> topicValues =
        await FirebaseRealTimeDatabaseAdapter.getAvailableObjects(
            fbReference!, DatabaseObjectName.topics);

    return topicValues.entries
        .map((topicEntry) => Topic(topicEntry.key, topicEntry.value));
  }

  Future<void> addTopics(List<Topic> topicsToAdd) async {
    Map<String, bool> topicValues = {
      for (var topic in topicsToAdd) topic.name: false
    };
    await FirebaseRealTimeDatabaseAdapter.addObjects(
        fbReference!, DatabaseObjectName.topics, topicValues);
  }
}
