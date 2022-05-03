import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

/// Base event for PlaceSelectBloc
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
class PlaceSelectBloc extends Bloc<BasePlaceEvent, List<String>> {
  final StudentSearchPageController studentSearchPageController;
  PlaceSelectBloc(this.studentSearchPageController) : super([]) {
    on<TogglePlaceEvent>(((event, emit) {
      final place = studentSearchPageController.places[event.index];
      if (state.contains(place.name)) {
        state.remove(place.name);
      } else {
        state.add(place.name);
      }
      emit(List<String>.from(state));
    }));
  }
}
