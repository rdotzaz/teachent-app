import 'package:flutter_bloc/flutter_bloc.dart';

/// Base event for RequestDayBloc
abstract class BaseMessageRefreshEvent {}

/// Event for refreshing messages widget.
class RefreshMessageWidget extends BaseMessageRefreshEvent {}

/// The class inherits from Bloc<Event, State>
///
/// Bloc object allows to manage state.
/// Bloc allows to refresh specific widgets (wrapped in BlocBuilder) after receiving event and emiting new state.
/// Such pattern improve widget rebuilding performance and better state management as well.
///
/// For more details: https://bloclibrary.dev/#/
class MessageRefreshBloc extends Bloc<BaseMessageRefreshEvent, bool> {
  MessageRefreshBloc() : super(false) {
    on<RefreshMessageWidget>(((event, emit) {
      emit(!state);
    }));
  }
}
