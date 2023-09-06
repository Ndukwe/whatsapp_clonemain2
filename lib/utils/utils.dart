
import 'dart:io';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context,required String content}){
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content:Text(content)
  ,),
);

}
Future<XFile?> pickImageFromGallery(BuildContext context) async{
  XFile? image;
  try{
    final pickedImage=
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      image=XFile(pickedImage.path);
    }
  }catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}


Future<XFile?> pickVideoFromGallery(BuildContext context) async{
  XFile? video;
  try{
    final pickedVideo=
    await ImagePicker().pickVideo(source: ImageSource.gallery);
    if(pickedVideo != null){
      video=XFile(pickedVideo.path);
    }
  }catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

Future<GiphyGif?>pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try{
  gif= await Giphy.getGif(context: context, apiKey: 'O539Agu42KYdV0t9eXbY4IJVcSD7LZBZ');
  }catch(e){
    showSnackBar(context: context, content: e.toString());
  }
  return gif;
}


