import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/controller/pages/student_request_page/bloc/request_day_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

class RequestDayField extends StatelessWidget {
  final StudentRequestPageController requestPageController;
  const RequestDayField(this.requestPageController, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            await requestPageController.enableDatePicker(context);
            context.read<RequestDayBloc>().add(ToggleRequestDayField());
          },
          child: Text(requestPageController.reqestedDate,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
        ),
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
