import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/education_level.dart';

/// Object representation of student (person who looking for private lessons)
class Student extends DatabaseObject {
  KeyId userId = DatabaseConsts.emptyKey;
  final String name;
  final EducationLevel educationLevel;
  final List<KeyId> requests;
  final List<KeyId> lessonDates;

  Student(this.userId, this.name, this.educationLevel, this.requests,
      this.lessonDates);

  Student.noKey(
      this.name, this.educationLevel, this.requests, this.lessonDates);

  // TODO - Remove this
  Student.onlyKeyName(this.userId, this.name, this.educationLevel)
      : requests = [],
        lessonDates = [];

  Student.fromMap(this.userId, Map<dynamic, dynamic> values)
      : name = values['name'] ?? '',
        educationLevel = EducationLevel(values['educationLevel'] ?? '', true),
        requests = DatabaseObject.getMapFromField(values, 'requests')
            .entries
            .map((id) => id.key.toString())
            .toList(),
        lessonDates = DatabaseObject.getMapFromField(values, 'lessonDates')
            .entries
            .map((id) => id.key.toString())
            .toList();

  @override
  String get collectionName => DatabaseObjectName.students;

  @override
  String get key => userId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'educationLevel': educationLevel.name,
      'requests': {for (var request in requests) request: true},
      'lessonDates': {for (var date in lessonDates) date: true}
    };
  }
}
