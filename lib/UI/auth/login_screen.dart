import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauth/UI/Post_screen/post_screen.dart';
import 'package:firebaseauth/UI/auth/Signup_Screen.dart';
import 'package:firebaseauth/UI/auth/login_with_phonenumber.dart';
import 'package:firebaseauth/Utils/utils.dart';
import 'package:firebaseauth/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool _obscureText= true;
   bool loading=false;
  final _formKey=GlobalKey<FormState>();
  final emailController =TextEditingController();
  final passwordController=TextEditingController();
  final _auth =FirebaseAuth.instance;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void login(){
    setState(() {
      loading=true;
    });
    _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString()).then((value){
 Utils().toastMessage(value.user!.email.toString());
 Navigator.push(context, MaterialPageRoute(builder:(context)=> PostScreen()));
 setState(() {
   loading=true;
 });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
Utils().toastMessage(error.toString());
      setState(() {
        loading=false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async{
        SystemNavigator.pop();
        return true;

      },

      child: Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login'),
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
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          suffixIcon:GestureDetector(
                            onTap: (){
                              setState(() {
                                _obscureText=!_obscureText;
                              });
                            },
                            child:Icon(_obscureText ?Icons.visibility_off :Icons.visibility) ,
                          ),


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
              RoundButton( title: 'Login',
              loading: loading,
              onTap: (){
                if(_formKey.currentState!.validate()){
                    login();
                }
              },),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(onPressed: (){
                    Navigator.push(context ,MaterialPageRoute(builder: (context)=>
                    SignUpScreen()) );
                  },
                      child: Text('Sign Up')),
                ],
              ),
              SizedBox(height: 25,),
              InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginWithPhoneNumber()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.cyan
                    )
                  ),
                  child: Center(
                    child: Text('Login With Phone '),
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}
