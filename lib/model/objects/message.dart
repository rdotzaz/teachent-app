class MessageField {
  final MessageRecord messageRecord;
  final bool isSender;

  MessageField(this.messageRecord, this.isSender);
}


class MessageRecord {
  final String message;
  final DateTime date;

  MessageRecord(this.message, this.date);
}
