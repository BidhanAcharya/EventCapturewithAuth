import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/UI/Post_screen/add_postscreen.dart';
import 'package:firebaseauth/UI/auth/login_screen.dart';
import 'package:firebaseauth/Utils/utils.dart';
import 'package:flutter/material.dart';
class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Post Screen '),
        centerTitle: true,
        actions: [
          InkWell(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPost()));
            } ,
            child: Icon(Icons.add),
          ),
          SizedBox(width: 15,),
          IconButton(onPressed: (){

         auth.signOut().then((value) {
           Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
         }).onError((error, stackTrace){
           Utils().toastMessage(error.toString());
         } );
          }, icon: Icon(Icons.logout)),





        ],
      ),
    );
  }
}
