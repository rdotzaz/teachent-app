import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

/// Base event for PersonTypeBloc
abstract class BasePersonTypeEvent {}

/// Event for selecting teacher and student either option
class ToggleAllEvent extends BasePersonTypeEvent {}

/// Event for selecting teacher only option
class ToggleTeachersOnlyEvent extends BasePersonTypeEvent {}

/// Event for selecting student only option
class ToggleStudentsOnlyEvent extends BasePersonTypeEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
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
