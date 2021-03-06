import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/review.dart';
import 'package:teachent_app/model/db_objects/teacher.dart';

/// Class for review management
class ReviewManager {
  /// Create new review by student with [studentId]. Add [title], [description] and [rate] to review.
  static Future<void> create(DataManager dataManager, Teacher teacher,
      KeyId studentId, String title, String description, int rate) async {
    final review = Review.noKey(studentId, teacher.userId, title, description,
        DateTime.now(), getReviewRateByValue(rate));
    final reviewId = await dataManager.database.addReview(review);

    final newAverageRate = getUpdatedAverageRate(teacher, rate);
    await dataManager.database
        .updateAverageRate(teacher.userId, newAverageRate);

    await dataManager.database.addReviewIdToStudent(studentId, reviewId);
    await dataManager.database.addReviewIdToTeacher(teacher.userId, reviewId);
  }

  /// Returns updated avarage rate based on [rate] for [teacher]
  static int getUpdatedAverageRate(Teacher teacher, int rate) {
    final currentAverageRate = teacher.averageRate;
    final currentReviewsCount = teacher.reviews.length;

    return (((currentAverageRate * currentReviewsCount) + rate) /
            (currentReviewsCount + 1))
        .ceil();
  }
}
