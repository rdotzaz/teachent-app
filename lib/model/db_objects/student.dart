import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/model/db_objects/db_object.dart';

import '../objects/education_level.dart';

class Student extends DatabaseObject {
  final KeyId userId;
  final String name;
  final EducationLevel educationLevel;
  final List<KeyId> requests;
  final List<KeyId> lessonDates;

  Student(this.userId, this.name, this.educationLevel,
      this.requests, this.lessonDates);

  Student.noKey(this.name, this.educationLevel, this.requests,
      this.lessonDates)
      : userId = DatabaseConsts.emptyKey;

  @override
  String get collectionName => DatabaseObjectName.students;

  @override
  String get key => userId;

  @override
  Map<String, dynamic> toMap() {
    final map = <String, String>{};
    return map;
  }
}
