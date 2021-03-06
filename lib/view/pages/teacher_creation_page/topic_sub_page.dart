import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/other_topic_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_creation/bloc/topic_bloc.dart';
import 'package:teachent_app/model/objects/topic.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

/// Sub page with form
/// User specifies lesson topics
/// This is one of the pages from PageView widget from teacher creation page
Widget topicSubPage(TeacherCreationPageController teacherController) {
  return BlocBuilder<TopicBloc, List<Topic>>(builder: (_, topics) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: CustomButton(
                            text: topics[index].name,
                            fontSize: 16,
                            onPressed: () {
                              context
                                  .read<TopicBloc>()
                                  .add(ToggleTopicEvent(index));
                            },
                            buttonColor: topics[index].marked
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
        text: TeacherCreationPageConsts.addOtherTopic,
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
              text: TeacherCreationPageConsts.add,
              fontSize: 14,
              onPressed: () {
                var topicName = _teacherController.getOtherTopicText();
                context.read<OtherTopicBloc>().add(UnclickOtherTopicEvent());
                context.read<TopicBloc>().add(AddNewTopic(topicName, context));
              },
              buttonColor: Colors.blue),
        )
      ],
    );
  }
}
