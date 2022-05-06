import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

import 'custom_button.dart';
import 'error_message_widget.dart';
import 'label.dart';
import 'single_card.dart';

class Messages extends StatefulWidget {
  final BaseRequestPageController controller;
  const Messages({ Key? key, required this.controller }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  void init() {
    widget.controller.init();
    widget.controller.refreshMessages = refresh;
  }

  @override
  void dispose() {
    widget.controller.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleCardWidget(
      title: 'Messages',
      titleColor: Colors.black,
      startAlignment: false,
      isNotEmptyCondition: widget.controller.hasAnyMessages,
      emptyWidget: ErrorMessageWidget(text: 'No messages'),
      bodyWidget: Column(
        children: [
          _messagesBody(),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.controller.textController,
                  onSubmitted: (value) => widget.controller.setValue(value)
                ),
              ),
              CustomButton(
                text: 'Send',
                fontSize: 14,
                onPressed: () => widget.controller.sendMessage()
              )
            ]
          )
        ]
      ),
    );
  }

  Widget _messagesBody() {
    final messages = widget.controller.messages;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.controller.messagesCount,
      itemBuilder: ((context, index) {
        final isSender = widget.controller.isSender(index);
        final message = messages[index].messageRecord.message;
        return Align(
          alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: isSender ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Label(
              text: message,
              color: Colors.white,
              fontSize: 10,
              padding: 5
            )
          )
        );
      })
    );
  }
}
