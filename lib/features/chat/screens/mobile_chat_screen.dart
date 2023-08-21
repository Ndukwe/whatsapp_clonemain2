import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import '../../../common/widgets/loader.dart';
import '../widgets/bottom_chat_field.dart';
import '/colors.dart';
import '/info.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName ='/mobile-chat-screen';
  final String name;
  final String uid;
  const MobileChatScreen({Key? key,required this.name,
    required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            print('show user Id ${snapshot.data!.uid}');
            if (snapshot.connectionState==ConnectionState.waiting){

              return const Loader();

            }
            return Column(
              children: [
                Text(name),
                Text(snapshot.data!.isOnline?'online':'offline',
                    style:const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal
                    )),
              ],
            );
          }
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
           // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.cake_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.monetization_on_outlined)),
              IconButton(onPressed: (){}, icon: Icon(Icons.message)),
            ],
          ),
           Expanded(
            child: ChatList(recieverUserId: uid,),
          ),
          BottomChatField(recieverUserId: uid,),
        ],
      ),
    );
  }
}


