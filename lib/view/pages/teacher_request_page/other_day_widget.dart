import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachent_app/common/date.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/teacher_request_page_controller.dart';
import 'package:teachent_app/controller/pages/teacher_request_page/bloc/refresh_bloc.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

class OtherDayWidget extends StatelessWidget {
  final TeacherRequestPageController controller;
  const OtherDayWidget({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Student has requested other day',
                  style: const TextStyle(fontSize: 18, color: Colors.black))),
          BlocBuilder<RefreshBloc, bool>(builder: (context, wasRejected) {
            return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(controller.requestedDate,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18))),
                  const SizedBox(width: 50),
                  CustomButton(
                    text: wasRejected ? 'Restore recjeted date' : 'Reject date',
                    onPressed: () => context.read<RefreshBloc>().add(
                        wasRejected ? RestoreDateEvent() : RejectDateEvent()),
                    fontSize: 18,
                    buttonColor: Colors.blue,
                  ),
                ]));
          })
        ]));
  }
}
