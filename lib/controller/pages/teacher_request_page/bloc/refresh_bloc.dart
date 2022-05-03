import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';

abstract class BaseRefreshEvent {}

class RejectDateEvent extends BaseRefreshEvent {}

class RestoreDateEvent extends BaseRefreshEvent {}

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
