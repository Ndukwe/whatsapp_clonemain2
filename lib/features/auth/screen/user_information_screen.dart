import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import '/utils/utils.dart';
import 'dart:io';


class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName='/user-information';
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController =TextEditingController();
  XFile? image;



  @override
  void  dispose(){
    super.dispose();
  nameController.dispose();

  }

  void selectImage() async{
  image= await pickImageFromGallery(context);
  setState(() {

  });
  }

  void storeUserData() async{
    // Convert XFile to File
    File file2 = File(image?.path ?? '');
    String name=nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, file2);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Convert XFile to File
    File file = File(image?.path ?? '');
    final size=MediaQuery.of(context).size;
    return  Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    image==null ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://images.pexels.com/photos/4420634/pexels-photo-4420634.jpeg?auto=compress&cs=tinysrgb&w=600'
                      ),
                      radius: 64,
                    ):CircleAvatar(
                      backgroundImage: FileImage(file),
                      radius: 64,
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width:size.width*0.85 ,
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: nameController,
                        decoration:const InputDecoration(
                          hintText: 'Enter your name'
                        ) ,
                      ),
                    ),
                    IconButton(onPressed: storeUserData,
                        icon: Icon(
                          Icons.done
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
    );
  }
}
