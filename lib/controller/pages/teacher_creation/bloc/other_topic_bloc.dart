import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/view/pages/teacher_creation_page/topic_sub_page.dart';

abstract class OtherTopicEvent {}

class ClickOtherTopicEvent extends OtherTopicEvent {}

class UnclickOtherTopicEvent extends OtherTopicEvent {}

class OtherTopicBloc extends Bloc<OtherTopicEvent, Widget> {
  final TeacherCreationPageController _teacherController;
  OtherTopicBloc(this._teacherController) : super(const OtherTopicButton()) {
    on<ClickOtherTopicEvent>((event, emit) {
      emit(OtherTopicLayout(_teacherController));
    });

    on<UnclickOtherTopicEvent>((event, emit) {
      emit(const OtherTopicButton());
    });
  }
}
