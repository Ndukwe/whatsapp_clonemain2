import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/utils/utils.dart';

import '../../../colors.dart';
import '../controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;

  const BottomChatField({super.key, required this.recieverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendBtn = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() {
    if (isShowSendBtn) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverUserId);

      setState(() {
        _messageController.text = "";
      });
    }
  }


  void sentFileMessage(
      File file,
      MessageEnum messageEnum,
      )async{
      ref.read(chatControllerProvider)
          .sendFileMessage(context, file, widget.recieverUserId, messageEnum);


  }

   void selectImage() async{
      XFile? image=await pickImageFromGallery(context);
      if(image !=null){
        // Convert XFile to File
        File file2 = File(image?.path ?? '');
          sentFileMessage(file2, MessageEnum.image);
      }
    
   }

  void selectVideo() async{
    XFile? video=await pickVideoFromGallery(context);
    if(video !=null){
      // Convert XFile to File
      File file2 = File(video?.path ?? '');
      sentFileMessage(file2, MessageEnum.video);
    }

  }
  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (val) {
              if (val.isNotEmpty) {
                setState(() {
                  isShowSendBtn = true;
                });
              } else {
                setState(() {
                  isShowSendBtn = false;
                });
              }
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: mobileChatBoxColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.gif,
                            color: Colors.grey,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    )),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                      onPressed: selectImage,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.grey,
                      ),
                      onPressed: selectVideo,
                    ),
                  ],
                ),
              ),
              hintText: 'Type a message!',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0, left: 2, right: 2),
          child: CircleAvatar(
            backgroundColor: Color(0xFF128C7E),
            radius: 25,
            child: GestureDetector(
                onTap: sendTextMessage,
                child: Icon(
                  isShowSendBtn == false ? Icons.mic : Icons.send,
                  color: Colors.white,
                )),
          ),
        )
      ],
    );
  }
}
