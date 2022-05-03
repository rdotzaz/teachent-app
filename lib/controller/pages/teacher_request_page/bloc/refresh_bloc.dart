import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';

/// Base event for RefreshBloc
abstract class BaseRefreshEvent {}

/// Set requested date by student as rejected
class RejectDateEvent extends BaseRefreshEvent {}

/// Set requested date by student as not rejected
class RestoreDateEvent extends BaseRefreshEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class RefreshBloc extends Bloc<BaseRefreshEvent, bool> {
  RefreshBloc(TeacherRequestPageController controller) : super(false) {
    on<RejectDateEvent>(((event, emit) {
      controller.rejectNewDate();
      emit(true);
    }));

    on<RestoreDateEvent>(((event, emit) {
      controller.restoreNewDate();
      emit(false);
    }));
  }
}
