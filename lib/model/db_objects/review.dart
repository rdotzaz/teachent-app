import 'package:teachent_app/common/consts.dart'
    show DatabaseConsts, DatabaseObjectName;
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';

/// Object representation of review from student about teacher
class Review extends DatabaseObject {
  final KeyId reviewId;
  final KeyId studentId;
  final KeyId teacherId;
  final String title;
  final String description;
  final DateTime date;
  final ReviewRate rate;

  Review(this.reviewId, this.studentId, this.teacherId, this.title,
      this.description, this.date, this.rate);

  Review.noKey(this.studentId, this.teacherId, this.title, this.description,
      this.date, this.rate)
      : reviewId = DatabaseConsts.emptyKey;

  Review.fromMap(this.reviewId, Map<dynamic, dynamic> values)
      : studentId = values['studentId'] ?? '',
        teacherId = values['teacherId'] ?? '',
        title = values['title'] ?? '',
        description = values['description'] ?? '',
        date = DateFormatter.parse(values['date'] ?? ''),
        rate = getReviewRateByValue(values['rate'] ?? 0);

  @override
  String get collectionName => DatabaseObjectName.reviews;

  @override
  String get key => reviewId;

  @override
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'teacherId': teacherId,
      'title': title,
      'description': description,
      'date': DateFormatter.getString(date),
      'rate': rate.value
    };
  }
}
