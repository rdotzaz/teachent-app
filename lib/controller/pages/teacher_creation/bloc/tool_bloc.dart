import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/tool.dart';

abstract class BaseToolEvent {}

class LoadAllToolsEvent extends BaseToolEvent {}

class ToggleToolEvent extends BaseToolEvent {
  final int index;

  ToggleToolEvent(this.index);
}

class AddNewToolEvent extends BaseToolEvent {
  final String name;
  final BuildContext context;

  AddNewToolEvent(this.name, this.context);
}

class ToolBloc extends Bloc<BaseToolEvent, List<Tool>> {
  ToolBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(_teacherCreationPageController.toolList) {
    on<LoadAllToolsEvent>((event, emit) async {
      await _teacherCreationPageController.initTools();
      emit(_teacherCreationPageController.toolList);
    });

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

    on<AddNewToolEvent>((event, emit) {
      var newTool = Tool(event.name, true);
      var isExists = _teacherCreationPageController.containsToolInAll(newTool);

      if (isExists) {
        _teacherCreationPageController.showErrorMessage(
            event.context, 'Such tool is already exists');
        return;
      }

      state.add(newTool);
      _teacherCreationPageController.tools.add(newTool.name);
      _teacherCreationPageController.addToAllTools(newTool);
      emit(List<Tool>.from(state));
    });
  }
}
