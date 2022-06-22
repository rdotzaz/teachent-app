import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';

/// Base event for RefreshBloc
abstract class BaseRefreshEvent {}

/// Set requested date by student as rejected
class RejectDateEvent extends BaseRefreshEvent {
  final BuildContext context;

  RejectDateEvent(this.context);
}

/// Set requested date by student as not rejected
class RestoreDateEvent extends BaseRefreshEvent {
  final BuildContext context;

  RestoreDateEvent(this.context);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class RefreshBloc extends Bloc<BaseRefreshEvent, RequestedDateStatus> {
  RefreshBloc(TeacherRequestPageController controller)
      : super(controller.request.dateStatus) {
    on<RejectDateEvent>(((event, emit) {
      controller.rejectNewDate(event.context);
      emit(RequestedDateStatus.rejected);
    }));

    on<RestoreDateEvent>(((event, emit) {
      controller.restoreNewDate(event.context);
      emit(RequestedDateStatus.accepted);
    }));
  }
}
