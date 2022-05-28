import 'package:flutter/material.dart';
import 'package:teachent_app/view/widgets/error_message_widget.dart';

/// Generic widget for object list.
/// If there are too many items on list, user can click 'More' button and see this page
class ListPage<T> extends StatelessWidget {
  final List<T> objects;
  final Widget Function(BuildContext context, int index) elementBuilder;
  final Future<void> Function() init;
  final String title;
  final Color color;
  const ListPage(
      {Key? key,
      required this.objects,
      required this.elementBuilder,
      required this.title,
      required this.init,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          leading: BackButton(color: color),
          expandedHeight: size.height / 4,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
              title: Text(
            title,
            style: TextStyle(color: color),
          )),
        ),
        FutureBuilder(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SliverList(
                  delegate: SliverChildListDelegate(
                      List<Widget>.generate(5, (_) => _emptyWidget())));
            } else if (snapshot.connectionState == ConnectionState.done) {
              return SliverList(
                  delegate: SliverChildListDelegate(List<Widget>.generate(
                      objects.length, (index) => _itemWidget(context, index))));
            }
            return ErrorMessageWidget(
                text: snapshot.error.toString(),
                backgroundColor: Colors.white,
                color: Colors.red);
          },
        )
      ],
    ));
  }

  Widget _itemWidget(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      child: elementBuilder(context, index),
    );
  }

  Widget _emptyWidget() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2))
        ],
      ),
      height: 80,
    );
  }
}
