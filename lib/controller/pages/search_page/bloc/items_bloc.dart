import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

/// Event for ItemsBloc
abstract class BaseItemsSearchEvent {}

/// Event to refresh found teachers and students lists
class RefreshItemsEvent extends BaseItemsSearchEvent {
  final String newPhrase;

  RefreshItemsEvent(this.newPhrase);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class ItemsBloc extends Bloc<BaseItemsSearchEvent, String> {
  ItemsBloc(TeacherSearchPageController searchController)
      : super(searchController.phrase) {
    on<RefreshItemsEvent>(((event, emit) async {
      if (searchController.phrase == event.newPhrase ||
          event.newPhrase.isEmpty) {
        return;
      }
      searchController.phrase = event.newPhrase;
      await searchController.updateTeachers();
      await searchController.updateStudents();
      emit(event.newPhrase);
    }));
  }
}
