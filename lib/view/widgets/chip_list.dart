import 'package:flutter/material.dart';

import 'single_card.dart';

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
