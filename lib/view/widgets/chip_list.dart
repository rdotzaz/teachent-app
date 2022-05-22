import 'package:flutter/material.dart';

import 'single_card.dart';

/// Custom SingleCardListWidget
/// Shows chips in horizontal view
/// Input:
/// [title] - title in top left corner of widget
/// [isNotEmptyCondition] - condition for list non-emptiness
/// [listLength] - length of the list
/// [emptyInfo] - information will be showed when there is no elements to show
/// [elementBuilder] - element builder callback
class ChipHorizontalList extends StatelessWidget {
  final String title;
  final bool isNotEmptyCondition;
  final int listLength;
  final String emptyInfo;
  final Widget Function(BuildContext context, int index) elementBuilder;
  const ChipHorizontalList(
      {Key? key,
      required this.title,
      required this.isNotEmptyCondition,
      required this.listLength,
      required this.elementBuilder,
      required this.emptyInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleCardListWidget(
        title: title,
        titleColor: Colors.black,
        boxHeight: 60,
        isNotEmptyCondition: isNotEmptyCondition,
        listLength: listLength,
        elementBackgroundColor:
            isNotEmptyCondition ? Colors.white : Colors.blue,
        elementPadding: 5,
        elementBottomMargin: 0,
        scrollDirection: Axis.horizontal,
        emptyInfo: emptyInfo,
        elementHeight: 50,
        padding: 10,
        margin: 8,
        elementBuilder: elementBuilder);
  }
}
