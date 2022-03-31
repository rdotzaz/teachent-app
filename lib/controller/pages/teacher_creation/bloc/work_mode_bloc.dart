import 'package:flutter_bloc/flutter_bloc.dart';

abstract class WorkModeEvent {}

class HomeWorkModeEvent extends WorkModeEvent {}

class RemoteWorkModeEvent extends WorkModeEvent {}

class AddingObjectEvent extends WorkModeEvent {}

class UnClickAddingObjectEvent extends WorkModeEvent {}

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
