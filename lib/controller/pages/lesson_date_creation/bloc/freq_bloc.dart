import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/controller.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';

abstract class BaseLessonFrequencyEvent {}

class ToggleFreqencyEvent extends BaseLessonFrequencyEvent {
  final int index;

  ToggleFreqencyEvent(this.index);
}

class ToggleCycleModeEvent extends BaseLessonFrequencyEvent {}

class FrequencyBloc extends Bloc<BaseLessonFrequencyEvent, int> {
  FrequencyBloc(LessonDateCreationPageController controller) : super(0) {
    on<ToggleFreqencyEvent>(((event, emit) {
      controller.toggleFreq(event.index);
      emit(event.index);
    }));

    on<ToggleCycleModeEvent>((event, emit) {
      controller.toggleCycleCheck();
      final refreshedState = state;
      emit(refreshedState);
    });
  }
}
