import 'dart:async';

import 'package:flutter/foundation.dart';

abstract class BlocBaseEvent {}

abstract class BlocBaseController<Data, Event extends BlocBaseEvent> {
  final _streamController = StreamController<Data>();
  final _eventsController = StreamController<Event>();

  BlocBaseController() {
    _eventsController.stream.listen(mapEvents);
  }

  Stream<Data> get data => _streamController.stream;
  Data get initialData;
  Sink<Event> get event => _eventsController.sink;

  @protected
  void addData(Data data) => _streamController.sink.add(data);

  void mapEvents(Event event);

  void dispose() {
    _streamController.close();
    _eventsController.close();
  }
}
