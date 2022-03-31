import 'package:flutter/material.dart';

import 'custom_button.dart';

enum BottomSheetStatus { error, success, info }

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
        return const Icon(Icons.error_outline, color: Colors.red, size: 90);
      case BottomSheetStatus.success:
        return const Icon(Icons.done, color: Colors.green, size: 90);
      default:
        return const Icon(Icons.info, color: Colors.blue, size: 90);
    }
  }

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    return SizedBox(
        height: windowSize.height / 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: const EdgeInsets.all(8.0), child: _getIcon()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                info,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            CustomButton(
                text: 'Ok',
                fontSize: 16,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ));
  }
}
