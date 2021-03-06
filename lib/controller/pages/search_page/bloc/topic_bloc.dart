import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

/// Base event for TopicSelectBloc
abstract class BaseTopicEvent {}

/// Event for select specific topic by [index]
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
class TopicSelectBloc extends Bloc<BaseTopicEvent, List<String>> {
  final StudentSearchPageController studentSearchPageController;
  TopicSelectBloc(this.studentSearchPageController) : super([]) {
    on<ToggleTopicEvent>(((event, emit) {
      final topic = studentSearchPageController.topics[event.index];
      if (state.contains(topic.name)) {
        state.remove(topic.name);
      } else {
        state.add(topic.name);
      }
      emit(List<String>.from(state));
    }));
  }
}
