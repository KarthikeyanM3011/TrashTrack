import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';
import 'dart:ui';
import 'stuffs.dart';

class Forgot_Password extends StatefulWidget {
  const Forgot_Password({super.key});

  @override
  State<Forgot_Password> createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
  bool _isLoading=false;
  TextEditingController mail = TextEditingController();

  Future<bool> reset(BuildContext context)async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail.text);
      showsnackbar(context, 'Password Reset mail sent', 2);
      setState(() {
        _isLoading=!_isLoading;
      });
      Navigator.of(context).pop();
      return true;
    }
    catch(e){
      if(e=='user-not-found'){
        showsnackbar(context, 'No User Found', 2);
      }
      else{
        showsnackbar(context, 'Unknown error occurred', 2);
      }
      setState(() {
        _isLoading=!_isLoading;
      });
      Navigator.of(context).pop();
      return false;
    }
  }

  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final halfScreenHeight = (screenHeight / 2);
    return StatefulBuilder(
      builder: (context,setState){
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: halfScreenHeight,
              child: AlertDialog(
                  title: Text('Forgot Password'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        txtfld(mail, "Enter Email"),
                          
                        ElevatedButton(
                          onPressed: ()async{
                            setState(() {
                              _isLoading=!_isLoading;
                            });
                            reset(context);
                            
                          },
                          child: Text('Send Mail',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          )
                          ),
                          
                      ],
                    ),
                  ),
              ),
            ),
          ),
        ),
      );
      },
    );
  }
}

