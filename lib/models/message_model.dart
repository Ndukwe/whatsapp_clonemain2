import 'package:whatsapp_ui/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String recieverId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final MessageEnum repliedMessageType;

  Message(
      {required this.repliedMessage,
      required this.repliedTo,
      required this.repliedMessageType,
      required this.senderId,
      required this.recieverId,
      required this.text,
      required this.type,
      required this.timeSent,
      required this.messageId,
      required this.isSeen});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'type': type.type,
      "timeSent": timeSent.toIso8601String(),
      "messageId": messageId,
      'isSeen': isSeen,
      'repliedMessage':repliedMessage,
      'repliedTo':repliedTo,
      'repliedMessageType': repliedMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverId: map['recieverId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.parse(map['timeSent']),
      // Use DateTime.parse here
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      repliedMessage:map['repliedMessage'] ?? '',
      repliedTo:map['repliedTo'] ?? '',
      repliedMessageType: (map['repliedMessageType'] as String).toEnum(),
    );
  }

//
}
