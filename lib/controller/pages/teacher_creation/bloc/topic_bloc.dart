import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/topic.dart';

abstract class BaseTopicEvent {}

class AddNewTopic extends BaseTopicEvent {
  final String name;

  AddNewTopic(this.name);
}

class ToggleTopicEvent extends BaseTopicEvent {
  final int index;

  ToggleTopicEvent(this.index);
}

class TopicBloc extends Bloc<BaseTopicEvent, List<Topic>> {
  TopicBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(_teacherCreationPageController.allTopics) {
    on<ToggleTopicEvent>((event, emit) {
      if (state[event.index].marked) {
        state[event.index].marked = false;
        _teacherCreationPageController.topics.remove(state[event.index].name);
      } else {
        state[event.index].marked = true;
        _teacherCreationPageController.topics.add(state[event.index].name);
      }
      emit(List<Topic>.from(state));
    });

    on<AddNewTopic>((event, emit) {
      var newTopic = Topic(event.name, true);
      state.add(newTopic);
      _teacherCreationPageController.topics.add(newTopic.name);
      _teacherCreationPageController.allTopics.add(newTopic);
      emit(List<Topic>.from(state));
    });
  }
}
