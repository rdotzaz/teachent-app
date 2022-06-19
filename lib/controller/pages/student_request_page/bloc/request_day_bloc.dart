import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/view/pages/student_request_page/request_day_button.dart';
import 'package:teachent_app/view/pages/student_request_page/request_day_field.dart';

/// Base event for RequestDayBloc
abstract class BaseRequestDayEvent {}

/// Event for showing [RequestDayButton] widget.
class ToggleRequestDayButton extends BaseRequestDayEvent {}

/// Event for showing [RequestDayField] widget
class ToggleRequestDayField extends BaseRequestDayEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class RequestDayBloc extends Bloc<BaseRequestDayEvent, Widget> {
  RequestDayBloc(StudentRequestPageController controller)
      : super(const RequestDayButton()) {
    on<ToggleRequestDayButton>(((event, emit) {
      emit(const RequestDayButton());
    }));

    on<ToggleRequestDayField>((event, emit) {
      emit(RequestDayField(controller));
    });
  }
}
