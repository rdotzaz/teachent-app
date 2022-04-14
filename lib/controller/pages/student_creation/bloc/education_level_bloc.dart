import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';
import 'package:teachent_app/model/objects/education_level.dart';

/// Base event for EducationLevelBloc
abstract class BaseEducationLevelEvent {}

/// Event to select education level at index from studentController.educationLevels
class ToggleEducationLevelEvent extends BaseEducationLevelEvent {
  final int index;

  ToggleEducationLevelEvent(this.index);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
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
