import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/search_page/teacher_search_page_controller.dart';

abstract class BaseItemsSearchEvent {}

class RefreshItemsEvent extends BaseItemsSearchEvent {
  final String newPhrase;

  RefreshItemsEvent(this.newPhrase);
}

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
