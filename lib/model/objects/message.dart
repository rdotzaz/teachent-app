/// Class representing message record on request page with information who is sender
class MessageField {
  final MessageRecord messageRecord;
  final bool isSender;

  MessageField(this.messageRecord, this.isSender);
}

/// Class representing single message with date of sending
class MessageRecord {
  final String message;
  final DateTime date;

  MessageRecord(this.message, this.date);
}
