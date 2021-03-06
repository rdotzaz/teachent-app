import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/bloc/refresh_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

/// Custom buttons for teacher request page
/// Input:
/// [controller] - controller from teacher request page
class Buttons extends StatelessWidget {
  final TeacherRequestPageController controller;
  const Buttons({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefreshBloc, RequestedDateStatus>(
        builder: (context, status) {
      return Column(children: [
        CustomButton(
            text: 'Accept request',
            fontSize: 18,
            onPressed: () => controller.acceptRequest(context),
            buttonColor: Colors.green),
        CustomButton(
            text: 'Reject request',
            fontSize: 18,
            onPressed: () => controller.rejectRequest(context),
            buttonColor: Colors.red),
      ]);
    });
  }
}
