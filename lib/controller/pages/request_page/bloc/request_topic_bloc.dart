import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/request_page/request_page_controller.dart';

abstract class BaseRequestTopicEvent {}

class ToggleTopicEvent extends BaseRequestTopicEvent {
  final int index;

  ToggleTopicEvent(this.index);
}

class RequestTopicBloc extends Bloc<BaseRequestTopicEvent, int> {
  RequestTopicBloc(RequestPageController controller) : super(controller.topicIndex) {
    on<ToggleTopicEvent>(((event, emit) {
      controller.setTopicIndex(event.index);
      emit(event.index);
    }));
  }
}
