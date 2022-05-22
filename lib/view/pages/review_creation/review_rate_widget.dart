import 'package:flutter/material.dart';
import 'package:teachent_app/controller/pages/review_creation/review_creation_page_controller.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

/// Widget used in review creation page
/// User can rate teacher by selecting number of stars
/// Input:
/// [controller] - review creation page controller
class ReviewRateWidget extends StatefulWidget {
  final ReviewCreationPageController controller;
  const ReviewRateWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ReviewRateWidget> createState() => _ReviewRateWidgetState();
}

class _ReviewRateWidgetState extends State<ReviewRateWidget> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleCardListWidget(
        title: 'Your rate',
        titleColor: Colors.black,
        boxHeight: 150,
        isNotEmptyCondition: true,
        scrollDirection: Axis.horizontal,
        listLength: 5,
        elementHeight: 80,
        elementBackgroundColor: Colors.white,
        elementBuilder: (context, index) {
          return GestureDetector(
            onTap: () => widget.controller.setRateNumber(index, refresh),
            child: Icon(Icons.star,
                size: 40,
                color: index + 1 <= widget.controller.rate
                    ? Colors.yellow
                    : Colors.grey),
          );
        },
        emptyInfo: 'No rate');
  }
}
