import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebaseauth/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool  showSpinner = false;
  final postRef= FirebaseDatabase.instance.ref().child('Posts');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseAuth _auth= FirebaseAuth.instance;
  File? _image;
  final picker=ImagePicker();
  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();


  Future  getGalleryImage()async{
       final pickedFile =await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if( pickedFile != null)
        {
          _image=File(pickedFile.path);
        }else{
        print('No image selected');
      }
    });
  }

  Future  getCameraImage()async{
    final pickedFile =await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if( pickedFile != null)
      {
        _image=File(pickedFile.path);
      }else{
        print('No image selected');
      }
    });
  }

  void dialog(context){
    showDialog(context: context,
        builder: (BuildContext){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        content:Container(
          height: 120,
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  getCameraImage();
                  Navigator.pop(context);

                },
                child:   ListTile(
                  leading: Icon(Icons.camera_alt_outlined),
                  title: Text('Camera'),
                ),
              ),
              InkWell(
                onTap: (){
              getGalleryImage();
              Navigator.pop(context);
                },
                child:   ListTile(
                  leading: Icon(Icons.photo_size_select_actual),
                  title: Text('Gallery'),
                ),
              )

            ],
          ),
        ) ,

      );
        });
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:showSpinner ,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Activities'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: 40,),
                InkWell(
                  onTap:(){
                    dialog(context);
                  } ,
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.height * .3,
                       color: Colors.grey[350],

                      child: _image !=null ? ClipRect(

                        child: Image.file(_image!.absolute,
                          height: 100,
                          width: 100,
                          fit:BoxFit.fill ,),

                      ):
                      Container(
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(20),
                        ),
                       // height: 100,
                        //width: 100,
                        child: Icon(Icons.camera_alt_outlined,
                          color: Colors.black87,),


                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Form(
                    child:Column(
                      children: [
                        TextFormField(
                          controller:titleController ,
                            keyboardType: TextInputType.text,
                            decoration:InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Title',
                              helperText: "What's on your mind",
                              prefixIcon: Icon(Icons.tab_outlined),
                            ) ,
                        ),
                        SizedBox(height: 18,),
                        TextFormField(
                          maxLines: 1,
                          maxLength: 250,
                          controller:descriptionController ,
                          keyboardType: TextInputType.text,
                          decoration:InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Description',
                            helperText: "Elaborate your thoughts",
                            prefixIcon: Icon(Icons.tab_outlined),
                          ) ,
                        ),


                      ],

                    ),),
                SizedBox(height: 25,),
                RoundButton(title: 'Post', onTap: ()async{

                  setState(() {
                    showSpinner=true;
                  });
                  try{
                    int date =DateTime.now().microsecondsSinceEpoch ;

                  firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/firebaseauth$date');
                  UploadTask uploadTask= ref.putFile(_image!.absolute);
                  await Future.value(uploadTask);
                  var newUrl = await ref.getDownloadURL();

                  final User? user =_auth.currentUser;
                  postRef.child('Post List').child(date.toString()).set({
                    'pId': date.toString(),
                    'pImage': newUrl.toString(),
                    'pTime': date.toString(),
                    'pTitle': titleController.text.toString(),
                    'pDescription': descriptionController.text.toString(),
                    'uEmail': user!.email.toString(),
                    'uid': user!.uid.toString(),



                  }).then((value) {
                    toastMessage('Post Published');
                    setState(() {
                      showSpinner=false;
                    });

                  }).onError((error, stackTrace){
                    toastMessage(error.toString());

                    setState(() {
                      showSpinner=false;
                    });

                  });
                  }catch(error){
                    setState(() {
                      showSpinner=false;
                    });

                    toastMessage(error.toString());


                  }

                }),
              ],

            ),
          ),
        ),
      ),
    );
  }
}
void toastMessage(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}
