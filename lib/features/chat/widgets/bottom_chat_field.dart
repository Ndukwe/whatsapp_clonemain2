import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';
import 'package:whatsapp_ui/utils/utils.dart';

import '../../../colors.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../controller/chat_controller.dart';
import 'message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;

  const BottomChatField({super.key, required this.recieverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendBtn = false;
  FlutterSoundRecorder? _soundRecorder;
  final TextEditingController _messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isShowEmojiContainer = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed !');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  Future<void> sendTextMessage() async {
    if (isShowSendBtn) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverUserId);

      setState(() {
        _messageController.text = "";
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sentFileMessage(File(path),MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sentFileMessage(
    File file,
    MessageEnum messageEnum,
  ) async {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.recieverUserId, messageEnum);
  }

  void selectImage() async {
    XFile? image = await pickImageFromGallery(context);
    if (image != null) {
      // Convert XFile to File
      File file2 = File(image?.path ?? '');
      sentFileMessage(file2, MessageEnum.image);
    }
  }

  void selectVideo() async {
    XFile? video = await pickVideoFromGallery(context);
    if (video != null) {
      // Convert XFile to File
      File file2 = File(video?.path ?? '');
      sentFileMessage(file2, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGIFMessage(context, gif.url, widget.recieverUserId);
    }
  }

  void hideEmojiContainier() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainier() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();

  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainier();
    } else {
      hideKeyboard();
      showEmojiContainier();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply=ref.watch(messageReplyProvider);
    final isShowMessageReply=messageReply!=null;
    return Column(

      children: [
        isShowMessageReply ?const MessageReplyPreview():const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
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
                              onPressed: toggleEmojiKeyboardContainer,
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
                              onPressed: selectGIF,
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
                      isShowSendBtn
                          ? Icons.send
                          : isRecording
                              ? Icons.close
                              : Icons.mic,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendBtn) {
                      setState(() {
                        isShowSendBtn = true;
                      });
                    }
                  }),
                ),
              )
            : SizedBox()
      ],
    );
  }
}
