import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

abstract class BasePersonTypeEvent {}

class ToggleAllEvent extends BasePersonTypeEvent {}

class ToggleTeachersOnlyEvent extends BasePersonTypeEvent {}

class ToggleStudentsOnlyEvent extends BasePersonTypeEvent {}

class PersonTypeBloc extends Bloc<BasePersonTypeEvent, PersonType> {
  final TeacherSearchPageController teacherSearchPageController;
  PersonTypeBloc(this.teacherSearchPageController) : super(PersonType.all) {
    on<ToggleAllEvent>(((event, emit) {
      if (state == PersonType.all) {
        return;
      }
      emit(PersonType.all);
    }));

    on<ToggleTeachersOnlyEvent>(((event, emit) {
      if (state == PersonType.teachers) {
        return;
      }
      emit(PersonType.teachers);
    }));

    on<ToggleStudentsOnlyEvent>(((event, emit) {
      if (state == PersonType.students) {
        return;
      }
      emit(PersonType.students);
    }));
  }
}
