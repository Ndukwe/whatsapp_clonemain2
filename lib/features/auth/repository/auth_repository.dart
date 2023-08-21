

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_ui/features/auth/screen/user_information_screen.dart';
import 'package:whatsapp_ui/models/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';
import 'package:whatsapp_ui/utils/utils.dart';

import '../../../common/respositories/common _firebase_storage_repository.dart';
import '../screen/otp_screen.dart';

final authRepositoryProvider =Provider((ref)=>AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    required this.firestore
});

 Future<UserModel?> getCurrentUserData() async{
   var userData=await firestore.collection('users').doc(auth.currentUser?.uid)
       .get();
   UserModel? user;
   if(userData.data() !=null){
      user=UserModel.fromMap(userData.data()!);
   }
   return user;
 }

  void signInWithPhone(BuildContext context,String phoneNumber) async{
    try{
       await  auth.verifyPhoneNumber(phoneNumber:phoneNumber,verificationCompleted: (PhoneAuthCredential credential) async {
         await auth.signInWithCredential(credential);
       }, verificationFailed: (e){
         throw Exception(e.message);
       }, codeSent: ((String verificationId,int? resendToken){
         Navigator.pushNamed(context, OTPScreen.routeName,arguments: verificationId);
       }), codeAutoRetrievalTimeout: (String verificationId){

       });
    }on FirebaseAuthException catch (e){
      showSnackBar(context: context, content: e.message!);
    }

  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  })async{
    try{
      PhoneAuthCredential credential=PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(context,
          UserInformationScreen.routeName, (route) => false);
    }on FirebaseAuthException catch(e){
      showSnackBar(context: context, content: e.message!);

    }
  }

  void saveUserDataToFirebase({
    required String name,
    File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
})async{
    try{
       String uid=auth.currentUser!.uid;
        String photoUrl='https://images.pexels.com/photos/4420634/pexels-photo-4420634.jpeg?auto=compress&cs=tinysrgb&w=600';
    if(profilePic != null){
     photoUrl=await ref.read(commonFirebaseStorageRepositoryProvider)
         .storeFileToFirebase('profilePic/$uid',
         profilePic);
    }
    var user=UserModel(name: name, uid: uid, profilePic: photoUrl, isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber.toString(),
        groupId: []);

    await firestore.collection('users').doc(uid).set(user.toMap());

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
            builder:(context) => const MobileLayoutScreen(),
        ),
            (route) => false,
    );
    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel>userData(String userId){

  return firestore.collection('users').doc(userId).snapshots().map
  ((event)=>UserModel.fromMap(event.data()!,

),
);
  }


   void setUserState(bool isOnline) async{
      await firestore.collection('users')
          .doc(auth.currentUser!.uid)
          .update({
             'isOnline':isOnline,
      });
   }
}