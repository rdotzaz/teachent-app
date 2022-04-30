import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';

abstract class BaseToolEvent {}

class ToggleToolEvent extends BaseToolEvent {
  final int index;

  ToggleToolEvent(this.index);
}

class ToolBloc extends Bloc<BaseToolEvent, List<bool>> {
  ToolBloc(LessonDateCreationPageController controller)
      : super(List<bool>.generate(controller.tools.length, (_) => false)) {
    on<ToggleToolEvent>(((event, emit) async {
      state[event.index] = !state[event.index];
      emit(List.from(state));
    }));
  }
}
