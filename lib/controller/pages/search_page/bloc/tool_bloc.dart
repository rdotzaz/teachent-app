import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

abstract class BaseToolEvent {}

class ToggleToolEvent extends BaseToolEvent {
  final int index;

  ToggleToolEvent(this.index);
}

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
