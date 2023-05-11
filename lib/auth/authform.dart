import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formkey = GlobalKey<FormState>();
  var _email;
  var _pw;
  var _username;
  bool _isloginpage = false;

  startauthentication(){
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(validity){
      _formkey.currentState!.save();
      submitform(_email,_pw,_username);
    }
  }

  submitform(String email, String password, String username)async{
    final auth = FirebaseAuth.instance;
    UserCredential userCredential;
    try{
      if(_isloginpage){
        userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
        userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username' : username,
          'email' : email
        });
      }
    }
    catch(err){
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(!_isloginpage)
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Incorrect Username';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _username = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('username'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Enter Username",
                          labelStyle: GoogleFonts.roboto()
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value){
                        if(value!.isEmpty || !value.contains('@')){
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Enter Email",
                          labelStyle: GoogleFonts.roboto()
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Incorrect Password';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _pw = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('password'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(),
                          ),
                          labelText: "Enter Password",
                          labelStyle: GoogleFonts.roboto()
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextButton(onPressed: (){
                        startauthentication();
                      }, child: _isloginpage
                          ? Text('Login', style: GoogleFonts.roboto(
                        fontSize: 16, color: Colors.white
                      ),) : Text('Sign Up', style: GoogleFonts.roboto(
                          fontSize: 16, color: Colors.white
                      ),)
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(onPressed: (){
                      setState(() {
                        _isloginpage = !_isloginpage;
                      });
                    },
                        child: _isloginpage ? Text('Not a Member?') : Text('Already a Member?')
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
