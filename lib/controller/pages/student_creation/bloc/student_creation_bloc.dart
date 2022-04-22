import 'package:bloc/bloc.dart';
import 'package:teachent_app/controller/pages/student_creation/student_creation_page_controller.dart';

abstract class BaseStudentEvent {}

class SwitchToNextPageEvent extends BaseStudentEvent {}

class SwitchToPrevPageEvent extends BaseStudentEvent {}

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
