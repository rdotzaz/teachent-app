import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/place_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/work_mode_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/enabled_button.dart';

Widget placeSubPage(TeacherCreationPageController teacherController) {
  return BlocBuilder<WorkModeBloc, int>(builder: (context, value) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            EnabledButton(
                text: 'In place',
                icon: Icons.home,
                onPressed: () {
                  context.read<WorkModeBloc>().add(HomeWorkModeEvent());
                },
                color: Colors.blue[100]!,
                enabledColor: Colors.blue,
                isEnabled: value == 1),
            EnabledButton(
                text: 'Remote',
                icon: Icons.computer,
                onPressed: () {
                  context.read<WorkModeBloc>().add(RemoteWorkModeEvent());
                },
                color: Colors.blue[100]!,
                enabledColor: Colors.blue,
                isEnabled: value == 2)
          ]),
          body(value)
        ]));
  });
}

Widget body(int value) {
  if (value == 0) {
    return emptyBodyWidget();
  } else if (value == 1) {
    return placeListWidget();
  } else {
    return toolListWidget();
  }
}

Widget emptyBodyWidget() {
  return Expanded(child: Container());
}

Widget placeListWidget() {
  return BlocBuilder<PlaceBloc, List<Place>>(builder: (_, places) {
    return Expanded(
        child: ListView.builder(
            itemCount: places.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: CustomButton(
                      text: places[index].name,
                      fontSize: 16,
                      onPressed: () {
                        context.read<PlaceBloc>().add(TogglePlaceEvent(index));
                      },
                      buttonColor: places[index].marked
                          ? Colors.blue
                          : Colors.blue[100]!));
            }));
  });
}

Widget toolListWidget() {
  return BlocBuilder<ToolBloc, List<Tool>>(builder: (_, tools) {
    return Expanded(
        child: ListView.builder(
            itemCount: tools.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: CustomButton(
                      text: tools[index].name,
                      fontSize: 16,
                      onPressed: () {
                        context.read<ToolBloc>().add(ToggleToolEvent(index));
                      },
                      buttonColor: tools[index].marked
                          ? Colors.blue
                          : Colors.blue[100]!));
            }));
  });
}
