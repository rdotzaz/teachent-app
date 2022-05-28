import 'dart:math';

import 'package:flutter/material.dart';

/// Loading placeholder for SingleCardWidget.
/// This widget will be painted till future function from FutureBuilder will return
/// Input:
/// [backgroundColor] - card background color
/// [title] - card title
/// [height] - placeholder card height
/// [margin] - placeholder card margin
class CardLoadingWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final double height;
  final double margin;
  const CardLoadingWidget(
      {Key? key,
      required this.backgroundColor,
      this.title = '',
      this.height = 100,
      this.margin = 12})
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
        margin: EdgeInsets.all(margin),
        height: height);
  }
}

class SingleCardWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final bool isNotEmptyCondition;
  final Widget bodyWidget;
  final Widget emptyWidget;
  final Color shadowColor;
  final Color titleColor;
  final bool startAlignment;
  final Widget? rightButton;
  final double margin;
  final double padding;
  const SingleCardWidget(
      {Key? key,
      this.backgroundColor = Colors.white,
      required this.title,
      this.isNotEmptyCondition = true,
      required this.bodyWidget,
      this.emptyWidget = const SizedBox(),
      this.titleColor = Colors.white,
      this.shadowColor = Colors.grey,
      this.startAlignment = true,
      this.rightButton,
      this.margin = 12,
      this.padding = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: shadowColor.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(2, 2))
          ],
        ),
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: startAlignment
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: rightButton != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(title,
                          style: TextStyle(fontSize: 24, color: titleColor))),
                  if (rightButton != null)
                    Padding(
                        padding: const EdgeInsets.all(15), child: rightButton)
                ]),
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
  final double elementPadding;
  final double elementBottomMargin;
  final Widget Function(BuildContext context, int index) elementBuilder;
  final Axis scrollDirection;
  final String emptyInfo;
  final IconData? emptyIcon;
  final double elementHeight;
  final double elementWidth;
  final Color shadowColor;
  final Color titleColor;
  final double padding;
  final double margin;
  final int maxElements;
  final Widget? moreButton;
  final Widget? rightButton;
  const SingleCardListWidget(
      {Key? key,
      this.backgroundColor = Colors.white,
      required this.title,
      required this.boxHeight,
      required this.isNotEmptyCondition,
      required this.listLength,
      required this.elementBackgroundColor,
      required this.elementBuilder,
      required this.emptyInfo,
      this.emptyIcon,
      this.rightButton,
      this.moreButton,
      this.shadowColor = Colors.grey,
      this.titleColor = Colors.white,
      this.elementHeight = 0.0,
      this.elementWidth = 0.0,
      this.scrollDirection = Axis.vertical,
      this.padding = 12,
      this.margin = 12,
      this.elementPadding = 12,
      this.elementBottomMargin = 10,
      this.maxElements = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleCardWidget(
      backgroundColor: backgroundColor,
      title: title,
      isNotEmptyCondition: isNotEmptyCondition,
      shadowColor: shadowColor,
      titleColor: titleColor,
      padding: padding,
      margin: margin,
      rightButton: rightButton,
      bodyWidget: bodyWidget(),
      emptyWidget: emptyWidget(),
    );
  }

  Widget bodyWidget() {
    if (moreButton != null && listLength > maxElements) {
      return Column(
        children: [
          elementHeight == 0.0
              ? listBuilderWidget()
              : SizedBox(height: elementHeight, child: listBuilderWidget()),
          moreButton!
        ],
      );
    } else {
      return elementHeight == 0.0
          ? listBuilderWidget()
          : SizedBox(height: elementHeight, child: listBuilderWidget());
    }
  }

  Widget listBuilderWidget() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: min(listLength, maxElements),
        scrollDirection: scrollDirection,
        itemBuilder: ((context, index) {
          if (elementWidth == 0.0) {
            return Container(
                decoration: BoxDecoration(
                  color: elementBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(elementPadding),
                margin: EdgeInsets.fromLTRB(0, 0, 0, elementBottomMargin),
                child: elementBuilder(context, index));
          }
          return Container(
              width: elementWidth,
              decoration: BoxDecoration(
                color: elementBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(elementPadding),
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: elementBuilder(context, index));
        }));
  }

  Widget emptyWidget() {
    return SizedBox(
        height: boxHeight,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emptyIcon != null)
              Padding(
                  padding: const EdgeInsets.all(15),
                  child:
                      Icon(emptyIcon, color: elementBackgroundColor, size: 70)),
            Text(emptyInfo,
                style: TextStyle(fontSize: 20, color: elementBackgroundColor))
          ],
        )));
  }
}
