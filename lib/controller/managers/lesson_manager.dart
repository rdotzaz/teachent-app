import 'package:flutter/material.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/model/db_objects/db_object.dart';
import 'package:teachent_app/model/db_objects/lesson.dart';
import 'package:teachent_app/model/db_objects/lesson_date.dart';

class LessonManager {
    static Future<void> createFirst(
           DataManager dataManager, KeyId studentId, LessonDate lessonDate) async {
        final lesson = Lesson.noKey(
            lessonDate.lessonDateId,
            lessonDate.teacherId,
            studentId,
            lessonDate.date,
            LessonStatus.open,
            DatabaseConsts.emptyKey
        );
        await dataManager.database.addLesson(lesson);
    }

    static Future<void> cancelLessonByTeacher(
            DataManager dataManager, LessonDate lessonDate, Lesson lesson) async {
        await LessonManager._cancelLesson(dataManager, lessonDate, lesson, true);
    }

    static Future<void> cancelLessonByStudent(
            DataManager dataManager, LessonDate lessonDate, Lesson lesson) async {
        await LessonManager._cancelLesson(dataManager, lessonDate, lesson, false);
    }

    static Future<void> _cancelLesson(
            DataManager dataManager, LessonDate lessonDate, Lesson lesson, bool isTeacher) async {
        await dataManager.database.updateLessonStatus(
            lesson.lessonDateId,
            isTeacher ? LessonStatus.teacherCancelled : LessonStatus.studentCancelled);
        
        if (lessonDate.isCycled) {
            final newDate = LessonManager._getNewDate(lessonDate, lesson);
            final newLesson = Lesson.noKey(
                lessonDate.lessonDateId,
                lessonDate.teacherId,
                lessonDate.studentId,
                newDate,
                LessonStatus.open,
                DatabaseConsts.emptyKey
            );

            await dataManager.database.addLesson(newLesson);
        }
    }

    static DateTime _getNewDate(LessonDate lessonDate, Lesson lesson) {
        int daysToAdd = 0;
        final cycleType = lessonDate.cycleType;
        assert (cycleType == CycleType.single);
        if (cycleType == CycleType.daily) {
            daysToAdd = 1;
        } else if (cycleType == CycleType.weekly) {
            daysToAdd = 7;
        } else if (cycleType == CycleType.biweekly) {
            daysToAdd = 14;
        } else if (cycleType == CycleType.monthly) {
            daysToAdd = 31;
        }
        return lesson.date.add(Duration(days: daysToAdd));
    }
}