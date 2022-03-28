import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/view/pages/teacher_creation_page.dart/topic_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

Widget topicSubPage(TeacherCreationPageController teacherController) {
  return BlocBuilder<TopicBloc, List<bool>>(builder: (_, stateList) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView.builder(
            itemCount: teacherController.tempAllTopics.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: CustomButton(
                      text: teacherController.tempAllTopics[index],
                      fontSize: 16,
                      onPressed: () {
                        context.read<TopicBloc>().add(ToggleTopicEvent(index));
                      },
                      buttonColor:
                          stateList[index] ? Colors.blue : Colors.blue[100]!));
            }));
  });
}
