import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/place_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/tool_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/work_mode_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/place.dart';
import 'package:teachent_app/model/objects/tool.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/enabled_button.dart';

/// Sub page with form
/// User specifies places (where user would like to lead lessons) or tools (which tools user would like to use to lead remote lessons)
/// This is one of the pages from PageView widget from teacher creation page
Widget placeSubPage(TeacherCreationPageController teacherController) {
  return BlocBuilder<WorkModeBloc, int>(builder: (context, value) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            EnabledButton(
                text: TeacherCreationPageConsts.inPlace,
                icon: Icons.home,
                onPressed: () {
                  context.read<WorkModeBloc>().add(HomeWorkModeEvent());
                },
                color: Colors.blue[100]!,
                enabledColor: Colors.blue,
                isEnabled: value == WorkModeConsts.place ||
                    value == WorkModeConsts.placeWithAdding),
            EnabledButton(
                text: TeacherCreationPageConsts.remote,
                icon: Icons.computer,
                onPressed: () {
                  context.read<WorkModeBloc>().add(RemoteWorkModeEvent());
                },
                color: Colors.blue[100]!,
                enabledColor: Colors.blue,
                isEnabled: value == WorkModeConsts.remote ||
                    value == WorkModeConsts.remoteWithAdding)
          ]),
          body(value),
          AddButtonWidget(teacherController: teacherController, value: value)
        ]));
  });
}

Widget body(int value) {
  if (value == WorkModeConsts.place ||
      value == WorkModeConsts.placeWithAdding) {
    return placeListWidget();
  } else if (value == WorkModeConsts.remote ||
      value == WorkModeConsts.remoteWithAdding) {
    return toolListWidget();
  }
  return emptyBodyWidget();
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

class AddButtonWidget extends StatelessWidget {
  final int value;
  final TeacherCreationPageController teacherController;
  const AddButtonWidget(
      {Key? key, required this.teacherController, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = value != WorkModeConsts.none;
    final isEditBox = value == WorkModeConsts.placeWithAdding ||
        value == WorkModeConsts.remoteWithAdding;
    final buttonName = value == WorkModeConsts.place
        ? TeacherCreationPageConsts.place
        : TeacherCreationPageConsts.tool;

    if (isEditBox) {
      return Row(
        children: [
          Expanded(
              child: TextField(
                  controller: teacherController.objectTextFieldController)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(
                text: TeacherCreationPageConsts.add,
                fontSize: 14,
                onPressed: () {
                  var objectName = teacherController.getOtherObjectText();
                  if (value == 3) {
                    context
                        .read<PlaceBloc>()
                        .add(AddNewPlaceEvent(objectName, context));
                  } else {
                    context
                        .read<ToolBloc>()
                        .add(AddNewToolEvent(objectName, context));
                  }
                  context.read<WorkModeBloc>().add(UnClickAddingObjectEvent());
                },
                buttonColor: Colors.blue),
          )
        ],
      );
    } else {
      return Container(
          height: 80,
          padding: const EdgeInsets.all(15.0),
          child: CustomButton(
              text: TeacherCreationPageConsts.addOther(buttonName),
              fontSize: 14,
              isEnabled: isEnabled,
              onPressed: () {
                context.read<WorkModeBloc>().add(AddingObjectEvent());
              }));
    }
  }
}
