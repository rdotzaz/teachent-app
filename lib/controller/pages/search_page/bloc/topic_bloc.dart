import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

abstract class BaseTopicEvent {}

class ToggleTopicEvent extends BaseTopicEvent {
  final int index;

  ToggleTopicEvent(this.index);
}

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
