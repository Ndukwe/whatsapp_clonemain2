
import 'package:whatsapp_ui/common/enums/message_enum.dart';

class Message{
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  Message({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.type,
    required  this.timeSent,
    required this.messageId,
    required this.isSeen
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      "timeSent": timeSent.toIso8601String(),
      "messageId": messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId']  ?? '',
      recieverId: map['recieverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.parse(map['timeSent']), // Use DateTime.parse here
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
    );
  }

//
}