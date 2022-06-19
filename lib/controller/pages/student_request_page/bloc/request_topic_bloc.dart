import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';

/// Base event for RequestTopicBloc
abstract class BaseRequestTopicEvent {}

/// Event for selecting topic with given [index]
class ToggleTopicEvent extends BaseRequestTopicEvent {
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
class RequestTopicBloc extends Bloc<BaseRequestTopicEvent, int> {
  RequestTopicBloc(StudentRequestPageController controller)
      : super(controller.topicIndex) {
    on<ToggleTopicEvent>(((event, emit) {
      controller.setTopicIndex(event.index);
      emit(event.index);
    }));
  }
}
