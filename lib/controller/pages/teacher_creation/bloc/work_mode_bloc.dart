import 'package:flutter_bloc/flutter_bloc.dart';

/// Event for WorkModeBloc
abstract class WorkModeEvent {}

/// Event for switching to in place work mode
/// Allows to selecting places
class HomeWorkModeEvent extends WorkModeEvent {}

/// Event for switching to in remote mode
/// Allows to selecting tools
class RemoteWorkModeEvent extends WorkModeEvent {}

/// Event for display textfield for new tool/place
class AddingObjectEvent extends WorkModeEvent {}

/// Event for hide textfield for new tool/place
class UnClickAddingObjectEvent extends WorkModeEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class WorkModeBloc extends Bloc<WorkModeEvent, int> {
  WorkModeBloc() : super(0) {
    on<HomeWorkModeEvent>((event, emit) => emit(1));

    on<RemoteWorkModeEvent>((event, emit) => emit(2));

    on<AddingObjectEvent>((event, emit) {
      if (state != 0 && state < 3) {
        emit(state + 2);
      }
    });

    on<UnClickAddingObjectEvent>((event, emit) {
      if (state > 2) {
        emit(state - 2);
      }
    });
  }
}
