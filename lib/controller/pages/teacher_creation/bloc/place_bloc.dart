import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/place.dart';

abstract class BasePlaceEvent {}

class TogglePlaceEvent extends BasePlaceEvent {
  final int index;

  TogglePlaceEvent(this.index);
}

class AddNewPlace extends BasePlaceEvent {
  final String name;

  AddNewPlace(this.name);
}

class PlaceBloc extends Bloc<BasePlaceEvent, List<Place>> {
  PlaceBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(_teacherCreationPageController.allPlaces) {
    on<TogglePlaceEvent>((event, emit) {
      if (state[event.index].marked) {
        state[event.index].marked = false;
        _teacherCreationPageController.places.remove(state[event.index]);
      } else {
        state[event.index].marked = true;
        _teacherCreationPageController.places.add(state[event.index].name);
      }
      emit(List<Place>.from(state));
    });

    on<AddNewPlace>((event, emit) {
      var newPlace = Place(event.name, true);
      state.add(newPlace);
      _teacherCreationPageController.places.add(newPlace.name);
      _teacherCreationPageController.allPlaces.add(newPlace);
      emit(List<Place>.from(state));
    });
  }
}
