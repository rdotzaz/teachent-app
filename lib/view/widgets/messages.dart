import 'package:flutter/material.dart';
import 'package:teachent_app/controller/controller.dart';

import 'error_widget.dart';
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
    controller.init();
    widget.controller.refreshMessages = refresh;
  }

  @override
  void dispose() {
    controller.dispose();
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
      isNotEmptyCondition: controller.hasAnyMessages,
      emptyWidget: ErrorWidget(text: 'No messages'),
      bodyWidget: Column(
        children: [
          _messagesBody(),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.textController,
                  onSubmitted: (value) => controller.setValue(value)
                ),
              ),
              CustomButton(
                text: 'Send',
                fontSize: 14,
                onPressed: controller.sendMessage(context)
              )
            ]
          )
        ]
      ),
    );
  }

  Widget _messagesBody() {
    final messages = controller.messages.sort((m1, m2) => m1.messageRecord.date.compareTo(m2.messageRecord.date));
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.messagesCount,
      itemBuilder: ((context, index) {
        final isSender = controller.isSender(index);
        final message = messages[index].messageRecord.message;
        return Align(
          alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            decorator: BoxDecoration(
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
        )
      })
    );
  }
}
