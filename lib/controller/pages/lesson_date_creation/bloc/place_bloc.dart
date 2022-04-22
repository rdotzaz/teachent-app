import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';

abstract class BasePlaceEvent {}

class TogglePlaceEvent extends BasePlaceEvent {
  final int index;

  TogglePlaceEvent(this.index);
}

class PlaceBloc extends Bloc<BasePlaceEvent, List<bool>> {
  PlaceBloc(LessonDateCreationPageController controller)
      : super(List<bool>.generate(controller.places.length, (_) => false)) {
    on<TogglePlaceEvent>(((event, emit) async {
        state[event.index] = !state[event.index];
        emit(List.from(state)); 
    }));
  }
}
