

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/UI/Post_screen/post_screen.dart';
import 'package:firebaseauth/UI/auth/login_screen.dart';
import 'package:flutter/material.dart';
class SplashServices{

void isLogin(BuildContext context) {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if (user != null) {
    Timer(const Duration(seconds: 5), () =>
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PostScreen())));
  } else{
    Timer(const Duration(seconds: 5), () =>
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));

  }
}
}