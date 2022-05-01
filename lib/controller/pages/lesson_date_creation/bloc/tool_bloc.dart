import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';

/// Base event for ToolBloc
abstract class BaseToolEvent {}

/// Event for select specific tool by [index]
class ToggleToolEvent extends BaseToolEvent {
  final int index;

  ToggleToolEvent(this.index);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class ToolBloc extends Bloc<BaseToolEvent, List<bool>> {
  ToolBloc(LessonDateCreationPageController controller)
      : super(List<bool>.generate(controller.tools.length, (_) => false)) {
    on<ToggleToolEvent>(((event, emit) async {
      state[event.index] = !state[event.index];
      emit(List.from(state));
    }));
  }
}
