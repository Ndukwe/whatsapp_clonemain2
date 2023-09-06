import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/models/message_model.dart';
import 'package:whatsapp_ui/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_ui/features/chat/widgets/sender_message_card.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/widgets/loader.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;

  const ChatList({Key? key, required this.recieverUserId}) : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController =ScrollController();


  @override
  void dispose(){
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
      String message,
      bool isMe,
      MessageEnum messageEnum,
      ){
    ref.read(messageReplyProvider.state).update((state) =>
        MessageReply(message, isMe, messageEnum),);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerProvider).chatStream(widget.recieverUserId),
        builder: (context, snapShot) {
          print('messages :${snapShot.data}');
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          final List<Message>? messages = snapShot.data;
          if (messages == null || messages.isEmpty) {

            return Center(child: Text("No messages"));
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController.jumpTo(messageController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: messageController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final messageData = messages[index];
                var timeSent = DateFormat.jm().format(messageData.timeSent);

                if(!messageData.isSeen && messageData.recieverId==FirebaseAuth.instance.currentUser!.uid){
                  ref.read(chatControllerProvider).setChatMessageSeen(context, widget.recieverUserId, messageData.messageId);
                }

                if (messageData.senderId ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  return MyMessageCard(
                    message: messageData.text,
                    date: timeSent,
                    type: messageData.type,
                    repliedText: messageData.repliedMessage,
                    username: messageData.repliedTo,
                    repliedMessageType: messageData.repliedMessageType,
                    onLeftSwipe: () =>onMessageSwipe(
                        messageData.text,
                        true,
                        messageData.type
                    ),
                    isSeen:messageData.isSeen,
                  );
                }
                return SenderMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  username: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  onRightSwipe: () =>onMessageSwipe(
                      messageData.text,
                      false,
                      messageData.type
                  ),
                  repliedText: messageData.repliedMessage,


                );
              });


          // return const Loader();
          //print('chatlist value:${snapShot.data!.length}');
        });
  }
}


