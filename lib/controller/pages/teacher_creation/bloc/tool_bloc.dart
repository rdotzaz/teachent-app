import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/tool.dart';

abstract class BaseToolEvent {}

class ToggleToolEvent extends BaseToolEvent {
  final int index;

  ToggleToolEvent(this.index);
}

class AddNewTool extends BaseToolEvent {
  final String name;

  AddNewTool(this.name);
}

class ToolBloc extends Bloc<BaseToolEvent, List<Tool>> {
  ToolBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(_teacherCreationPageController.allTools) {
    on<ToggleToolEvent>((event, emit) {
      if (state[event.index].marked) {
        state[event.index].marked = false;
        _teacherCreationPageController.tools.remove(state[event.index]);
      } else {
        state[event.index].marked = true;
        _teacherCreationPageController.tools.add(state[event.index].name);
      }
      emit(List<Tool>.from(state));
    });

    on<AddNewTool>((event, emit) {
      var newTool = Tool(event.name, true);
      state.add(newTool);
      _teacherCreationPageController.tools.add(newTool.name);
      _teacherCreationPageController.allTools.add(newTool);
      emit(List<Tool>.from(state));
    });
  }
}
