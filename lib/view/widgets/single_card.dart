import 'package:flutter/material.dart';

class SingleCardWidget extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final bool isNotEmptyCondition;
  final Widget bodyWidget;
  final Widget? emptyWidget;
  final Color shadowColor;
  final Color titleColor;
  final bool startAlignment;
  final Widget? rightButton;
  const SingleCardWidget(
      {Key? key,
      required this.backgroundColor,
      required this.title,
      this.isNotEmptyCondition = true,
      required this.bodyWidget,
      this.emptyWidget,
      this.titleColor = Colors.white,
      this.shadowColor = Colors.white,
      this.startAlignment = true,
      this.rightButton})
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
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
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
    return isNotEmptyCondition ? bodyWidget : (emptyWidget ?? Container());
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
  final IconData? emptyIcon;
  final double elementHeight;
  final double elementWidth;
  final Color shadowColor;
  final Color titleColor;
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
      this.emptyIcon,
      this.shadowColor = Colors.white,
      this.titleColor = Colors.white,
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
      shadowColor: shadowColor,
      titleColor: titleColor,
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
    return ListView.builder(
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
                      Icon(emptyIcon!, color: elementBackgroundColor, size: 70)),
            Text(emptyInfo,
                style: TextStyle(fontSize: 20, color: elementBackgroundColor))
          ],
        )));
  }
}
