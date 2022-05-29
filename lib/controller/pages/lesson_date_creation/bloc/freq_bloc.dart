import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/lesson_date_creation/lesson_date_creation_controller.dart';

/// Base event for FrequencyBloc
abstract class BaseLessonFrequencyEvent {}

/// Event for select frequency mode by [index]
class ToggleFreqencyEvent extends BaseLessonFrequencyEvent {
  final int index;

  ToggleFreqencyEvent(this.index);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class FrequencyBloc extends Bloc<BaseLessonFrequencyEvent, int> {
  FrequencyBloc(LessonDateCreationPageController controller) : super(0) {
    on<ToggleFreqencyEvent>(((event, emit) {
      controller.toggleFreq(event.index);
      emit(event.index);
    }));
  }
}
