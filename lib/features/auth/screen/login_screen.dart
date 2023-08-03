import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';
import 'package:whatsapp_ui/utils/utils.dart';

import '../../../common/widgets/custom_button.dart';


class LoginScreen extends ConsumerStatefulWidget {
  static const routeName='/route';
  LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  Country? country;
  final phoneController=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }
  void pickCountry(){
    showCountryPicker(context: context, onSelect: (Country _country){
      setState(() {
        country= _country;
      });
    });
  }

  void sendPhoneNumber(){
    String phoneNumber=phoneController.text.trim();
    if(country!=null && phoneNumber.isNotEmpty){
      ref.read(authRepositoryProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    }else{
      showSnackBar(context: context, content: 'fill out all the fields');
    }
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation:0 ,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
   children:  [
     const Text('WhatsApp will need to verify your phone number'),
     const SizedBox(height: 10,),
     TextButton(onPressed:pickCountry,
         child: Text('Pick Country'),
     ),
     const SizedBox(height: 10,),
     Row(
         children: [
           if(country!=null)
           Text('+${country!.phoneCode}'),
           SizedBox(width: 10,),
           SizedBox(width: size.width*0.7,
           child: TextField(
             controller: phoneController,
             decoration: const InputDecoration(
               hintText: 'phone number'
             ),
           ),),
         ],
     ),
     SizedBox(height:size.height*0.5),
     SizedBox(
       width: 90,
       child: CustomButton(text: 'NEXT',
         onPressed: sendPhoneNumber,

       ),
     )
   ],
        ),
      ),

    );
  }
}
