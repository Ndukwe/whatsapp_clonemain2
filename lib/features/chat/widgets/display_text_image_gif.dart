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
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(videoUrl: message)
            : CachedNetworkImage(
                imageUrl: message,
              );
  }
}
