import 'package:flutter/material.dart';

import 'custom_button.dart';

enum BottomSheetStatus { error, success, info }

void showErrorMessage(BuildContext context, String info) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          StatusBottomSheet(info: info, status: BottomSheetStatus.error));
}

class StatusBottomSheet extends StatelessWidget {
  final String info;
  final BottomSheetStatus status;
  const StatusBottomSheet({
    Key? key,
    required this.info,
    required this.status,
  }) : super(key: key);

  Icon _getIcon() {
    switch (status) {
      case BottomSheetStatus.error:
        return const Icon(Icons.error_outline, color: Colors.red, size: 150);
      case BottomSheetStatus.success:
        return const Icon(Icons.done, color: Colors.green, size: 150);
      default:
        return const Icon(Icons.info, color: Colors.blue, size: 150);
    }
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(25)),
        height: windowSize.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: _getIcon()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                info,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            CustomButton(
                text: 'Ok',
                fontSize: 20,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ));
  }
}
