

import 'dart:async';
import 'package:firebaseauth/UI/auth/login_screen.dart';
import 'package:flutter/material.dart';
class SplashServices{
void isLogin(BuildContext context){
  Timer(const Duration(seconds: 5),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen())));
}

}