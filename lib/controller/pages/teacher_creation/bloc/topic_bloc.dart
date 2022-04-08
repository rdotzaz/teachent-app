import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/topic.dart';

/// Event for TopicBloc
abstract class BaseTopicEvent {}

/// Event for loading all topics from database
class LoadAllTopicsEvent extends BaseTopicEvent {}

/// Event for adding new topic to available topics
class AddNewTopic extends BaseTopicEvent {
  final String name;
  final BuildContext context;

  AddNewTopic(this.name, this.context);
}

/// Event for toggle topic at [index] from [_teacherCreationPageController.topicList]
class ToggleTopicEvent extends BaseTopicEvent {
  final int index;

  ToggleTopicEvent(this.index);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class TopicBloc extends Bloc<BaseTopicEvent, List<Topic>> {
  TopicBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(_teacherCreationPageController.topicList) {
    on<LoadAllTopicsEvent>((event, emit) async {
      await _teacherCreationPageController.initTopics();
      emit(_teacherCreationPageController.topicList);
    });

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
      var isExists =
          _teacherCreationPageController.containsTopicInAll(newTopic);

      if (isExists) {
        _teacherCreationPageController.showErrorMessage(
            event.context, TeacherCreationPageConsts.topicExists);
        return;
      }

      state.add(newTopic);
      _teacherCreationPageController.topics.add(newTopic.name);
      _teacherCreationPageController.addToAllTopics(newTopic);
      emit(List<Topic>.from(state));
    });
  }
}
