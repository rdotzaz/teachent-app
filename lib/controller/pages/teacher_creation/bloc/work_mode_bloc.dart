import 'package:flutter_bloc/flutter_bloc.dart';

abstract class WorkModeEvent {}

class HomeWorkModeEvent extends WorkModeEvent {}

class RemoteWorkModeEvent extends WorkModeEvent {}

class WorkModeBloc extends Bloc<WorkModeEvent, int> {
  WorkModeBloc() : super(0) {
    on<HomeWorkModeEvent>((event, emit) => emit(1));

    on<RemoteWorkModeEvent>((event, emit) => emit(2));
  }
}
