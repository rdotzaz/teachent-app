import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/controller.dart';

/// Event for ItemsBloc
abstract class BaseItemsSearchEvent {}

/// Event to refresh found teachers and students lists
class RefreshItemsEvent extends BaseItemsSearchEvent {
  final String newPhrase;
  final PersonType personType;

  RefreshItemsEvent(this.newPhrase, this.personType);
}

class RefreshTeacherItemsEvent extends BaseItemsSearchEvent {
  final String newPhrase;
  final List<String> topicNames;
  final List<String> toolNames;
  final List<String> placeNames;

  RefreshTeacherItemsEvent(
      this.newPhrase, this.topicNames, this.toolNames, this.placeNames);
}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class ItemsBloc extends Bloc<BaseItemsSearchEvent, String> {
  ItemsBloc(BaseSearchController searchController)
      : super(searchController.phrase) {
    on<RefreshItemsEvent>(((event, emit) async {
      if (searchController.phrase == event.newPhrase ||
          event.newPhrase.isEmpty) {
        return;
      }
      searchController.phrase = event.newPhrase;
      await searchController.updateFoundList(event.personType);
      emit('');
      emit(event.newPhrase);
    }));

    on<RefreshTeacherItemsEvent>(((event, emit) async {
      if (searchController.phrase == event.newPhrase ||
          event.newPhrase.isEmpty) {
        return;
      }
      searchController.phrase = event.newPhrase;
      await searchController.updateFoundTeacherList(
          event.topicNames, event.toolNames, event.placeNames);
      emit('');
      emit(event.newPhrase);
    }));
  }
}
