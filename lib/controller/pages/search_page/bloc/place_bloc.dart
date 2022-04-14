import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/student_search_page_controller.dart';

abstract class BasePlaceEvent {}

class TogglePlaceEvent extends BasePlaceEvent {
  final int index;

  TogglePlaceEvent(this.index);
}

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
