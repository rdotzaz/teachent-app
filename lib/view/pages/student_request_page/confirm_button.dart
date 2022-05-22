import 'package:flutter/material.dart';
import 'package:teachent_app/common/enums.dart';
import 'package:teachent_app/common/enum_functions.dart';
import 'package:teachent_app/controller/pages/student_request_page/student_request_page_controller.dart';
import 'package:teachent_app/view/widgets/custom_button.dart';

/// Custom button used in Student request page
/// Button behaviour changes in case of request state
/// Input:
/// [controller] - controller from student request page
class ConfirmButton extends StatelessWidget {
  final StudentRequestPageController controller;
  const ConfirmButton({required this.controller, Key? key}) : super(key: key);

  String _buttonText(RequestStatus status, bool hasChangesProvided) {
    if (status == RequestStatus.newReq) {
      return 'Send request for lesson';
    }
    if (hasChangesProvided) {
      return 'Send response';
    }
    return status.stringValue;
  }

  Future<void> _onPressed(BuildContext context, RequestStatus status,
      bool hasChangesProvided) async {
    if (status == RequestStatus.newReq) {
      await controller.sendRequest(context);
      return;
    }
    if (status == RequestStatus.responded) {
      if (hasChangesProvided) {
        await controller.sendResponse(context);
      }
    }
  }

  Color _getColor(RequestStatus status, bool hasChangesProvided) {
    if (status == RequestStatus.waiting || hasChangesProvided) {
      return Colors.blue;
    }
    if (status == RequestStatus.responded) {
      return Colors.cyanAccent;
    }
    if (status == RequestStatus.rejected) {
      return Colors.red;
    }
    if (status == RequestStatus.newReq || status == RequestStatus.accepted) {
      return Colors.green;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final status = controller.request?.status ?? RequestStatus.newReq;
    final hasChangesProvided = controller.hasChangesProvided;
    return Container(
        margin: const EdgeInsets.all(15),
        child: CustomButton(
            text: _buttonText(status, hasChangesProvided),
            fontSize: 18,
            onPressed: () => _onPressed(context, status, hasChangesProvided),
            isEnabled: hasChangesProvided || controller.request == null,
            buttonColor: _getColor(status, hasChangesProvided)));
  }
}
