import 'package:bloc/bloc.dart';

import '../teacher_creation_page_controller.dart';

/// Event for TeacherCreationBloc
abstract class BaseTeacherEvent {}

/// Event for switching to next page
class SwitchToNextPageEvent extends BaseTeacherEvent {}

/// Event for switching to previous page
class SwitchToPrevPageEvent extends BaseTeacherEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class TeacherCreationBloc extends Bloc<BaseTeacherEvent, int> {
  TeacherCreationBloc(TeacherCreationPageController controller) : super(0) {
    on<SwitchToPrevPageEvent>((event, emit) {
      if (state == 0) {
        return;
      }
      controller.moveToPage(state - 1);
      emit(state - 1);
    });

    on<SwitchToNextPageEvent>((event, emit) {
      if (state == 2) {
        return;
      }
      if (state == 0) {
        var isValidated = controller.validateFields();
        if (!isValidated) {
          return;
        }
      }
      controller.moveToPage(state + 1);
      emit(state + 1);
    });
  }
}
