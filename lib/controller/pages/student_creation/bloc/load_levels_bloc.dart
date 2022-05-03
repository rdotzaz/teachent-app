import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';

/// Event for LoadLevelsBloc
abstract class BaseLoadEducationLevelsEvent {}

/// Event for loading all education levels from database
class LoadAllLevelsEvent extends BaseLoadEducationLevelsEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class LoadLevelsBloc
    extends Bloc<BaseLoadEducationLevelsEvent, List<EducationLevel>> {
  LoadLevelsBloc(StudentCreationPageController studentController)
      : super(studentController.educationLevels) {
    on<LoadAllLevelsEvent>((event, emit) async {
      await studentController.initLevels();
    });
  }
}
