import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

/// Base event for ToolSelectBloc
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
class ToolSelectBloc extends Bloc<BaseToolEvent, List<String>> {
  final StudentSearchPageController studentSearchPageController;
  ToolSelectBloc(this.studentSearchPageController) : super([]) {
    on<ToggleToolEvent>(((event, emit) {
      final tool = studentSearchPageController.tools[event.index];
      if (state.contains(tool.name)) {
        state.remove(tool.name);
      } else {
        state.add(tool.name);
      }
      emit(List<String>.from(state));
    }));
  }
}
