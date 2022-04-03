import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';

abstract class BaseLoadEducationLevelsEvent {}

class LoadAllLevelsEvent extends BaseLoadEducationLevelsEvent {}

class LoadLevelsBloc
    extends Bloc<BaseLoadEducationLevelsEvent, List<EducationLevel>> {
  LoadLevelsBloc(StudentCreationPageController studentController)
      : super(studentController.educationLevels) {
    on<LoadAllLevelsEvent>((event, emit) async {
      await studentController.initLevels();
    });
  }
}
