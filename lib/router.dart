

import 'package:flutter/material.dart';
import 'package:whatsapp_ui/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screen/user_information_screen.dart';

import 'common/widgets/error.dart';
import 'features/auth/screen/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings){

  switch(settings.name){

    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context)=> LoginScreen(),
      );

    case OTPScreen.routeName:
      final verificationIdn=settings.arguments as  String;
      return MaterialPageRoute(builder: (context)=>  OTPScreen(
        verificationId: verificationIdn,
      ),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context)=>  UserInformationScreen(
      ),
      );
    default:
      return MaterialPageRoute(builder: (context)=>const Scaffold(
        body:ErrorScreen(error: 'This page does not exist',) ,
      ),);
  }

}