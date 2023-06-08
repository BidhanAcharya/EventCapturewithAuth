

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
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
  final dbRef =FirebaseDatabase.instance.ref().child('Posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
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
      body: Column(
        children: [
          Expanded(
              child: FirebaseAnimatedList(
                query: dbRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.height * .3,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/ocean.jpg',
                                  image: (snapshot.value as dynamic)['pImage']),
                            ),

                        ),
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                            child:  Text('Thoughts : ${(snapshot.value as dynamic) ['pTitle']}',style: TextStyle(fontSize: 20),),
                          ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(25, 12, 25, 10),
                          child: Text('Elaborate: \n\n${(snapshot.value as dynamic) ['pDescription']}',style: TextStyle(color: Colors.brown),),
                        ),
                        Divider(
                          height: 25.0,
                          color: Colors.grey[800],
                        ),
                          ],
                    );
                },
              ),
          )
        ],
      ),
    );
  }
}
