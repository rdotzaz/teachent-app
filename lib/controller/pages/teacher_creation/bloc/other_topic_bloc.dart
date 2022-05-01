import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/view/pages/teacher_creation_page/topic_sub_page.dart';

/// Event for OtherTopicBloc
abstract class OtherTopicEvent {}

/// Event for clicking "Add new topic" button.
/// Emit widget with textfield and submit button for adding new topic
class ClickOtherTopicEvent extends OtherTopicEvent {}

/// Event for hiding textfield and submit button for adding new topic.
class UnclickOtherTopicEvent extends OtherTopicEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
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
