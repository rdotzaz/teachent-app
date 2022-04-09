import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/controller.dart';

abstract class BaseItemsSearchEvent {}

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
      emit(event.newPhrase);
    }));
  }
}
