import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/view/pages/student_request_page/request_day_button.dart';
import 'package:teachent_app/view/pages/student_request_page/request_day_field.dart';

abstract class BaseRequestDayEvent {}

class ToggleRequestDayButton extends BaseRequestDayEvent {}

class ToggleRequestDayField extends BaseRequestDayEvent {}

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
