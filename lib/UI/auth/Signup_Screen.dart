import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/UI/auth/login_screen.dart';
import 'package:firebaseauth/Utils/utils.dart';
import 'package:firebaseauth/widgets/round_button.dart';
import 'package:flutter/material.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading =false;
  final emailController =TextEditingController();
  final passwordController=TextEditingController();
  final  nameController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }
  void signup(){
    setState(() {
      loading =true;
    });
    _auth.createUserWithEmailAndPassword(email: emailController.text.toString(),
        password: passwordController.text.toString()).then((value){
      setState(() {
        loading =false;
      });

    } ).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading =false;
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign Up'),
        centerTitle: true,



      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller:nameController ,
                    decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person)

                    ),
                    validator:(value){
                      if(value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value!)){
                        return'Name should be alphabet ';}
                      else{
                        return null;
                      }
                    } ,
                  ),
                  SizedBox(height: 20,),


                  TextFormField(
                    controller:emailController ,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email)

                    ),
                    validator:(value){
                      if(value!.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}').hasMatch(value!)){
                        return'Enter email in correct format';}
                      else{
                        return null;
                      }
                    } ,
                  ),
                  SizedBox(height: 20,),

                  TextFormField(

                      controller:passwordController ,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock)


                      ),
                      validator:(value){
                        if(value!.isEmpty || !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value!)){
                          return'Weak Password ';}
                        else{
                          return null;
                        }
                      }

                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RoundButton( title: 'Sign Up',
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                     signup();
                }
              },),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){

                  Navigator.push(context ,MaterialPageRoute(builder: (context)=>
                      LoginScreen()) );
                },
                    child: Text('Login')),
              ],
            )
          ],
        ),
      ),

    );
  }
}
