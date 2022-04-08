import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/consts.dart';
import 'package:teachent_app/controller/pages/teacher_creation/teacher_creation_page_controller.dart';
import 'package:teachent_app/model/objects/place.dart';

/// Event for PlaceBloc
abstract class BasePlaceEvent {}

/// Event for loading all available places
class LoadAllPlacesEvent extends BasePlaceEvent {}

/// Event for toggle place at [index] from [_teacherCreationPageController.placeList]
class TogglePlaceEvent extends BasePlaceEvent {
  final int index;

  TogglePlaceEvent(this.index);
}

/// Event for adding new place to available places
class AddNewPlaceEvent extends BasePlaceEvent {
  final String name;
  final BuildContext context;

  AddNewPlaceEvent(this.name, this.context);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class PlaceBloc extends Bloc<BasePlaceEvent, List<Place>> {
  PlaceBloc(TeacherCreationPageController _teacherCreationPageController)
      : super(_teacherCreationPageController.placeList) {
    on<LoadAllPlacesEvent>((event, emit) async {
      await _teacherCreationPageController.initPlaces();
      emit(_teacherCreationPageController.placeList);
    });

    on<TogglePlaceEvent>((event, emit) {
      if (state[event.index].marked) {
        state[event.index].marked = false;
        _teacherCreationPageController.places.remove(state[event.index].name);
      } else {
        state[event.index].marked = true;
        _teacherCreationPageController.places.add(state[event.index].name);
      }
      emit(List<Place>.from(state));
    });

    on<AddNewPlaceEvent>((event, emit) {
      var newPlace = Place(event.name, true);
      var isExists =
          _teacherCreationPageController.containsPlaceInAll(newPlace);

      if (isExists) {
        _teacherCreationPageController.showErrorMessage(
            event.context, TeacherCreationPageConsts.placeExists);
        return;
      }

      state.add(newPlace);
      _teacherCreationPageController.places.add(newPlace.name);
      _teacherCreationPageController.addToAllPlaces(newPlace);
      emit(List<Place>.from(state));
    });
  }
}
