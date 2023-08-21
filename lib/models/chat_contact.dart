

class ChatContact{
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact({
     required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage
  });

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "profilePic": this.profilePic,
      "contactId": this.contactId,
      "timeSent": this.timeSent.toIso8601String(),
      "lastMessage": this.lastMessage,
    };
  }

  factory ChatContact.fromJson(Map<String, dynamic> json) {
    return ChatContact(
      name: json["name"] ??'',
      profilePic: json["profilePic"]??'',
      contactId: json["contactId"]??'',
      timeSent: DateTime.parse(json["timeSent"]),
      lastMessage: json["lastMessage"]??'',
    );
  }
//
}