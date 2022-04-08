import 'package:bloc/bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';

/// Event for StudentCreationBloc
abstract class BaseStudentEvent {}

/// Event for switching to next page
class SwitchToNextPageEvent extends BaseStudentEvent {}

/// Event for switching to previous page
class SwitchToPrevPageEvent extends BaseStudentEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class StudentCreationBloc extends Bloc<BaseStudentEvent, int> {
  StudentCreationBloc(StudentCreationPageController controller) : super(0) {
    on<SwitchToPrevPageEvent>((event, emit) {
      if (state == 0) {
        return;
      }
      controller.moveToPage(state - 1);
      emit(state - 1);
    });

    on<SwitchToNextPageEvent>((event, emit) {
      if (state == 1) {
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
