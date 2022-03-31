import 'package:bloc/bloc.dart';

import '../teacher_creation_page_controller.dart';

abstract class BaseTeacherEvent {}

class SwitchToNextPageEvent extends BaseTeacherEvent {}

class SwitchToPrevPageEvent extends BaseTeacherEvent {}

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
