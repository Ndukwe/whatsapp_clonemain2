import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/chat/widgets/video_player_item.dart';

import '../../../common/enums/message_enum.dart';

class DisplayTextImageGiF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  DisplayTextImageGiF({Key? key, required this.type, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(
                builder: (context, setState) {
                  return IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 100,
                      ),
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                          setState((){
                            isPlaying=false;
                          });
                        } else {
                          await audioPlayer.play(UrlSource(message));
                          setState((){
                            isPlaying=true;
                          });
                        }
                      },
                      icon:  Icon(isPlaying?Icons.pause_circle:Icons.play_circle));
                },
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                :type == MessageEnum.gif
        ? CachedNetworkImage(
      imageUrl: message,
    )
        : CachedNetworkImage(
      imageUrl: message,
    );
  }
}
