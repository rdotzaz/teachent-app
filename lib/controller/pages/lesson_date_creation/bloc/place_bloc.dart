import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';

/// Base event for PlaceBloc
abstract class BasePlaceEvent {}

/// Event for select specific place by [index]
class TogglePlaceEvent extends BasePlaceEvent {
  final int index;

  TogglePlaceEvent(this.index);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class PlaceBloc extends Bloc<BasePlaceEvent, List<bool>> {
  PlaceBloc(LessonDateCreationPageController controller)
      : super(List<bool>.generate(controller.places.length, (_) => false)) {
    on<TogglePlaceEvent>(((event, emit) async {
      state[event.index] = !state[event.index];
      emit(List.from(state));
    }));
  }
}
