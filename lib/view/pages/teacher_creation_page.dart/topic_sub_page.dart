import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/other_topic_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_creation/topic_bloc.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

Widget topicSubPage(TeacherCreationPageController teacherController) {
  return BlocBuilder<TopicBloc, List<bool>>(builder: (_, stateList) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: teacherController.tempAllTopics.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: CustomButton(
                            text: teacherController.tempAllTopics[index],
                            fontSize: 16,
                            onPressed: () {
                              context
                                  .read<TopicBloc>()
                                  .add(ToggleTopicEvent(index));
                            },
                            buttonColor: stateList[index]
                                ? Colors.blue
                                : Colors.blue[100]!));
                  }),
            ),
            BlocBuilder<OtherTopicBloc, Widget>(builder: (_, widget) {
              return Container(
                  height: 80,
                  padding: const EdgeInsets.all(15.0),
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 700),
                      child: widget));
            })
          ],
        ));
  });
}

class OtherTopicButton extends StatelessWidget {
  const OtherTopicButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        text: 'Add other topic',
        fontSize: 14,
        onPressed: () {
          context.read<OtherTopicBloc>().add(ClickOtherTopicEvent());
        });
  }
}

class OtherTopicLayout extends StatelessWidget {
  final TeacherCreationPageController _teacherController;
  const OtherTopicLayout(this._teacherController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextField(
                controller: _teacherController.topicTextFieldController)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomButton(
              text: 'Add',
              fontSize: 14,
              onPressed: () {
                _teacherController.addTopicToList(
                    Topic(_teacherController.getOtherTopicText()));
                context.read<OtherTopicBloc>().add(UnclickOtherTopicEvent());
                context.read<TopicBloc>().add(AddNewTopic());
              },
              buttonColor: Colors.blue),
        )
      ],
    );
  }
}
