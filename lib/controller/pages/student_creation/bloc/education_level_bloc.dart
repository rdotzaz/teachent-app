import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';

abstract class BaseEducationLevelEvent {}

class ToggleEducationLevelEvent extends BaseEducationLevelEvent {
  final int index;

  ToggleEducationLevelEvent(this.index);
}

class EducationLevelBloc
    extends Bloc<BaseEducationLevelEvent, EducationLevel?> {
  EducationLevelBloc(StudentCreationPageController studentController)
      : super(null) {
    on<ToggleEducationLevelEvent>((event, emit) {
      var levels = studentController.educationLevels;
      studentController.educationLevel = levels[event.index].name;
      emit(levels[event.index]);
    });
  }
}
