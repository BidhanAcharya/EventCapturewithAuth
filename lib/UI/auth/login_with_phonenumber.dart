import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/UI/auth/verify_with_code.dart';
import 'package:firebaseauth/Utils/utils.dart';
import 'package:firebaseauth/widgets/round_button.dart';
import 'package:flutter/material.dart';
class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading =false;
  final phoneNumberController = TextEditingController();
  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 80,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: Colors.black
                  ),
              ),
              child: Center(
                child: Text(' Enter Phone Number',style: TextStyle(fontSize: 24),),
              ),



            ),
          ),
          SizedBox(height: 25,),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: TextFormField(
                controller :phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration:InputDecoration(
                  hintText: '+977 9867032145',
                    helperText: 'Include Country code too',
                    prefixIcon: Icon(Icons.phone),


                ) ,
              ),
            ),
          ),
           SizedBox(height: 50,),
         Container(
           width: 130,
           child: RoundButton(title: 'Login',loading: loading, onTap:(){
             setState(() {
               loading=true;
             });
        auth.verifyPhoneNumber(
            phoneNumber:phoneNumberController.text ,
            verificationCompleted:(_){
              setState(() {
                loading=false;
              });
            } ,
            verificationFailed:(error){
              setState(() {
                loading=false;
              });
              Utils().toastMessage(error.toString());
            } ,
            codeSent: (String verificationID, int? token){
              Navigator.push(context, MaterialPageRoute(builder:(context)=>VerifyCodeScreen(verificationId: verificationID,) ));

              setState(() {
                loading=false;
              });


            },
            codeAutoRetrievalTimeout: (error){
              Utils().toastMessage(error.toString());
              setState(() {
                loading=false;
              });
            });
           }),
         )
        ],
      ),
    );
  }
}
