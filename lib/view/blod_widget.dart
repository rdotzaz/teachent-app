import 'package:flutter/material.dart';
import 'package:teachent_app/controller/bloc_controller.dart';

typedef BlocWidgetBuilder<Data> = Widget Function(
    BuildContext, AsyncSnapshot<Data>);

class BlocWidget<Data, Event extends BlocBaseEvent> extends StatelessWidget {
  final BlocBaseController<Data, Event> bloc;
  final BlocWidgetBuilder<Data> builder;

  const BlocWidget({Key? key, required this.bloc, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Data>(
      stream: bloc.data,
      initialData: bloc.initialData,
      builder: builder,
    );
  }
}
