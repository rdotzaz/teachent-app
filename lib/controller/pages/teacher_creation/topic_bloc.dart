import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';

abstract class BaseTopicEvent {}

class AddNewTopic extends BaseTopicEvent {}

class ToggleTopicEvent extends BaseTopicEvent {
  final int index;

  ToggleTopicEvent(this.index);
}

class TopicBloc extends Bloc<BaseTopicEvent, List<bool>> {
  TopicBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(List<bool>.filled(
            _teacherCreationPageController.tempAllTopics.length, false)) {
    on<ToggleTopicEvent>((event, emit) {
      state[event.index] = !state[event.index];
      emit(List<bool>.from(state));
    });

    on<AddNewTopic>((_, emit) {
      state.add(true);
      emit(List<bool>.from(state));
    });
  }
}
