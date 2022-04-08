import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/tool.dart';

/// Event for ToolBloc
abstract class BaseToolEvent {}

/// Event for loading all available tools from database
class LoadAllToolsEvent extends BaseToolEvent {}

/// Event for toggle tool at [index] from [_teacherCreationPageController.toolList]
class ToggleToolEvent extends BaseToolEvent {
  final int index;

  ToggleToolEvent(this.index);
}

/// Event for adding new tool to available tools
class AddNewToolEvent extends BaseToolEvent {
  final String name;
  final BuildContext context;

  AddNewToolEvent(this.name, this.context);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
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
            event.context, TeacherCreationPageConsts.toolExists);
        return;
      }

      state.add(newTool);
      _teacherCreationPageController.tools.add(newTool.name);
      _teacherCreationPageController.addToAllTools(newTool);
      emit(List<Tool>.from(state));
    });
  }
}
