import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

import 'custom_button.dart';
import 'error_message_widget.dart';
import 'label.dart';
import 'single_card.dart';

class Messages extends StatefulWidget {
  final BaseRequestPageController controller;
  const Messages({Key? key, required this.controller}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleCardWidget(
      title: 'Messages',
      titleColor: Colors.black,
      startAlignment: false,
      bodyWidget: Column(children: [
        _messagesBody(),
        const SizedBox(height: 30),
        Row(children: [
          Expanded(
            child: TextField(controller: widget.controller.textController),
          ),
          CustomButton(
              text: 'Send',
              fontSize: 14,
              onPressed: () {
                widget.controller.sendMessageAndRefresh(refresh);
              })
        ])
      ]),
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
