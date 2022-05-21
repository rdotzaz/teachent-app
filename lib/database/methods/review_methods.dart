import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/database/adapters/firebase_adapter.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/review.dart';

/// Methods to maintain Review object in database
mixin ReviewDatabaseMethods {
  /// Method returns all reviews which have [teacherId]
  Future<List<Review>> getReviewsByTeacherId(KeyId teacherId) async {
    return await _getReviewsByUserId('teacherId', teacherId);
  }

  /// Method returns all reviews which have [studentId]
  Future<List<Review>> getReviewsByStudentId(KeyId studentId) async {
    return await _getReviewsByUserId('studentId', studentId);
  }

  /// Method adds new reivew to database
  Future<KeyId> addReview(Review review) async {
    final key =
        await FirebaseRealTimeDatabaseAdapter.addDatabaseObjectWithNewKey(
            DatabaseObjectName.reviews, review.toMap());
    return key;
  }

  Future<List<Review>> _getReviewsByUserId(
      String property, KeyId userId) async {
    final reviewsValues =
        await FirebaseRealTimeDatabaseAdapter.getObjectsByProperty(
            DatabaseObjectName.reviews, property, userId);

    final reviews = <Review>[];
    reviewsValues.forEach((key, reviewValues) {
      if (reviewValues.isEmpty) {
        return;
      }
      reviews.add(Review.fromMap(key, reviewValues));
    });
    return reviews;
  }
}
