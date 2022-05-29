import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/bloc/refresh_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';
import 'package:teachent_app/view/widgets/single_card.dart';

/// Widget for reject requested new date
/// Input:
/// [controller] - controller from teacher request page
class OtherDayWidget extends StatelessWidget {
  final TeacherRequestPageController controller;
  const OtherDayWidget({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleCardWidget(
        title: 'Student has requested other day',
        titleColor: Colors.black,
        bodyWidget: BlocBuilder<RefreshBloc, RequestedDateStatus>(
            builder: (context, status) {
          return Column(children: [
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text(controller.requestedDate,
                    style: const TextStyle(color: Colors.black, fontSize: 18))),
            const SizedBox(width: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Accept date',
                  onPressed: () =>
                      context.read<RefreshBloc>().add(RestoreDateEvent()),
                  fontSize: 18,
                  buttonColor: Colors.green,
                ),
                CustomButton(
                  text: 'Reject date',
                  onPressed: () =>
                      context.read<RefreshBloc>().add(RejectDateEvent()),
                  fontSize: 18,
                  buttonColor: Colors.red,
                ),
              ],
            )
          ]);
        }));
  }
}
