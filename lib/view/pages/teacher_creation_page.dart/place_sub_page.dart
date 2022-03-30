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
                isEnabled: value == 1 || value == 3),
            EnabledButton(
                text: 'Remote',
                icon: Icons.computer,
                onPressed: () {
                  context.read<WorkModeBloc>().add(RemoteWorkModeEvent());
                },
                color: Colors.blue[100]!,
                enabledColor: Colors.blue,
                isEnabled: value == 2 || value == 4)
          ]),
          body(value),
          AddButtonWidget(teacherController: teacherController, value: value)
        ]));
  });
}

Widget body(int value) {
  if (value == 1 || value == 3) {
    return placeListWidget();
  } else if (value == 2 || value == 4) {
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
    final isEnabled = value != 0;
    final isEditBox = value == 3 || value == 4;
    final buttonName = value == 1 ? 'place' : 'tool';

    if (isEditBox) {
      return Row(
        children: [
          Expanded(
              child: TextField(
                  controller: teacherController.objectTextFieldController)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomButton(
                text: 'Add',
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
              text: 'Add other $buttonName',
              fontSize: 14,
              isEnabled: isEnabled,
              onPressed: () {
                context.read<WorkModeBloc>().add(AddingObjectEvent());
              }));
    }
  }
}
