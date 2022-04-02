import 'package:flutter/material.dart';

class SingleCardWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final bool isNotEmptyCondition;
  final Widget bodyWidget;
  final Widget emptyWidget;
  const SingleCardWidget(
      {Key? key,
      required this.backgroundColor,
      required this.title,
      required this.isNotEmptyCondition,
      required this.bodyWidget,
      required this.emptyWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: backgroundColor.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(2, 2))
          ],
        ),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(15),
                child: Text(title,
                    style: const TextStyle(fontSize: 24, color: Colors.white))),
            builderWidget(),
          ],
        ));
  }

  Widget builderWidget() {
    return isNotEmptyCondition ? bodyWidget : emptyWidget;
  }
}

class SingleCardListWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final double boxHeight;
  final bool isNotEmptyCondition;
  final int listLength;
  final Color elementBackgroundColor;
  final Widget Function(BuildContext context, int index) elementBuilder;
  final Axis scrollDirection;
  final String emptyInfo;
  final IconData emptyIcon;
  final double elementHeight;
  final double elementWidth;
  const SingleCardListWidget(
      {Key? key,
      required this.backgroundColor,
      required this.title,
      required this.boxHeight,
      required this.isNotEmptyCondition,
      required this.listLength,
      required this.elementBackgroundColor,
      required this.elementBuilder,
      required this.emptyInfo,
      required this.emptyIcon,
      this.elementHeight = 0.0,
      this.elementWidth = 0.0,
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleCardWidget(
      backgroundColor: backgroundColor,
      title: title,
      isNotEmptyCondition: isNotEmptyCondition,
      bodyWidget: bodyWidget(),
      emptyWidget: emptyWidget(),
    );
  }

  Widget bodyWidget() {
    if (elementHeight == 0.0) {
      return listBuilderWidget();
    }
    return SizedBox(height: elementHeight, child: listBuilderWidget());
  }

  Widget listBuilderWidget() {
    return SizedBox(
      child: ListView.builder(
          shrinkWrap: elementHeight == 0.0,
          itemCount: listLength,
          scrollDirection: scrollDirection,
          itemBuilder: ((context, index) {
            if (elementWidth == 0.0) {
              return Container(
                  decoration: BoxDecoration(
                    color: elementBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: elementBuilder(context, index));
            }
            return Container(
                width: elementWidth,
                decoration: BoxDecoration(
                  color: elementBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: elementBuilder(context, index));
          })),
    );
  }

  Widget emptyWidget() {
    return SizedBox(
        height: boxHeight,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(emptyIcon, color: Colors.white)),
            Text(emptyInfo,
                style: const TextStyle(fontSize: 14, color: Colors.white))
          ],
        )));
  }
}
