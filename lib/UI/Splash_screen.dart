import 'package:firebaseauth/Firebase_Services/Splash_Services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen =SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  splashScreen.isLogin(context);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen',style: TextStyle(fontSize: 30),),
      ),
    );
  }
}
