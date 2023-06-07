import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/UI/Post_screen/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../Utils/utils.dart';
import '../../widgets/round_button.dart';
class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading =false;
  final VerifyCodeController = TextEditingController();
  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 25,),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: TextFormField(
                controller :VerifyCodeController,
                keyboardType: TextInputType.phone,
                decoration:InputDecoration(
                  hintText: 'Enter 6 digit code',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide:
                    BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),

                  prefixIcon: Icon(Icons.phone),


                ) ,
              ),
            ),
          ),
          SizedBox(height: 50,),
          Container(
            width: 130,
            child: RoundButton(title: 'Verify',loading: loading, onTap:()async{
              setState(() {
                loading =true;
              });
            final credentials = PhoneAuthProvider.credential(
                verificationId: widget.verificationId, smsCode:VerifyCodeController.text.toString() );

            try{
              await auth.signInWithCredential(credentials);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> PostScreen()));
            } catch(error){
              setState(() {
                loading =true;
              });
              Utils().toastMessage(error.toString());
            }
            }),
          )
        ],
      ),
    );
  }
}




