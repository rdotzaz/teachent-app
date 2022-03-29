import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/bloc/education_level_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

Widget educationLevelSubPage(StudentCreationPageController studentController) {
  return BlocBuilder<EducationLevelBloc, EducationLevel?>(builder: (_, level) {
    return Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: studentController.educationLevels.length,
                  itemBuilder: (context, index) {
                    final name = studentController.educationLevels[index].name;
                    final isEnabled = level?.name == name;

                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: CustomButton(
                            text: name,
                            fontSize: 16,
                            onPressed: () {
                              context
                                  .read<EducationLevelBloc>()
                                  .add(ToggleEducationLevelEvent(index));
                            },
                            buttonColor:
                                isEnabled ? Colors.red : Colors.red[100]!));
                  }),
            )
          ],
        ));
  });
}
