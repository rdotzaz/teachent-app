import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

/// Custom field with date label to specify new date by student
class RequestDayField extends StatelessWidget {
  final StudentRequestPageController requestPageController;
  const RequestDayField(this.requestPageController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestedDate = requestPageController.requestedDate.isNotEmpty
        ? requestPageController.requestedDate
        : requestPageController.currentDate;
    final requestedTime = requestPageController.requestedTime.isNotEmpty
        ? requestPageController.requestedTime
        : requestPageController.currentTime;
    return SingleCardWidget(
      title: 'Request new date',
      titleColor: Colors.black,
      bodyWidget: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () =>
                      requestPageController.toggleRequestDatePicker(context),
                  child: Text(requestedDate,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () =>
                      requestPageController.toggleRequestTimePicker(context),
                  child: Text(requestedTime,
                      style:
                          const TextStyle(fontSize: 18, color: Colors.black)),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                  text: 'Save',
                  fontSize: 14,
                  onPressed: () {
                    requestPageController.saveRequestedDate();
                    context
                        .read<RequestDayBloc>()
                        .add(ToggleRequestDayButton());
                  },
                  buttonColor: Colors.blue),
              CustomButton(
                  text: 'Cancel',
                  fontSize: 14,
                  onPressed: () {
                    requestPageController.cancelRequestedDate();
                    context
                        .read<RequestDayBloc>()
                        .add(ToggleRequestDayButton());
                  },
                  buttonColor: Colors.blue)
            ],
          )
        ],
      ),
    );
  }
}
