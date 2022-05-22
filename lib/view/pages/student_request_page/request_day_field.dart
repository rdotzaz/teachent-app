import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

/// Custom field with date label to specify new date by student
class RequestDayField extends StatelessWidget {
  final StudentRequestPageController requestPageController;
  const RequestDayField(this.requestPageController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestedDate = requestPageController.requestedDate.isNotEmpty
        ? requestPageController.requestedDate
        : requestPageController.date;
    return Row(
      children: [
        GestureDetector(
          onTap: () => requestPageController.toggleRequestDatePicker(context),
          child: Text(requestedDate,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
        ),
        CustomButton(
            text: 'Save',
            fontSize: 14,
            onPressed: () {
              requestPageController.saveRequestedDate();
              context.read<RequestDayBloc>().add(ToggleRequestDayButton());
            },
            buttonColor: Colors.blue),
        CustomButton(
            text: 'Cancel',
            fontSize: 14,
            onPressed: () {
              requestPageController.cancelRequestedDate();
              context.read<RequestDayBloc>().add(ToggleRequestDayButton());
            },
            buttonColor: Colors.blue)
      ],
    );
  }
}
