import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

import 'error_message_widget.dart';
import 'label.dart';
import 'single_card.dart';

/// Widget for displaying chat inside teacher/student request page
/// Input:
/// [controller] - controller from teacher/student request page
class Messages extends StatefulWidget {
  final BaseRequestPageController controller;
  const Messages({Key? key, required this.controller}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return SingleCardWidget(
      title: 'Messages',
      titleColor: Colors.black,
      startAlignment: false,
      bodyWidget: _messagesBody(),
    );
  }

  Widget _messagesBody() {
    if (!widget.controller.hasAnyMessages) {
      return const ErrorMessageWidget(
          text: 'No messages',
          backgroundColor: Colors.white,
          color: Colors.red);
    }
    final messages = widget.controller.messages;
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.controller.messagesCount,
        itemBuilder: ((context, index) {
          final isSender = widget.controller.isSender(index);
          final message = messages[index].messageRecord.message;
          return Align(
              alignment:
                  isSender ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                  decoration: BoxDecoration(
                    color: isSender ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.all(8),
                  child: Label(
                      text: message,
                      color: Colors.white,
                      fontSize: 14,
                      padding: 8)));
        }));
  }
}
