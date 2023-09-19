import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'details_screen.dart';
import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';
import 'forgetpass_screen.dart';
import 'stuffs.dart';
import 'main.dart';

class Log_In extends StatefulWidget {
  const Log_In({super.key});

  @override
  State<Log_In> createState() => _Log_InState();
}

bool _autherror=false;
class _Log_InState extends State<Log_In> {
  
  bool hide = true;
  bool _isLoading = false;
  bool _mailpass=false;
  
  TextEditingController user = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController mail = TextEditingController();
  

  void signin()async{
    setState(() {
      _isLoading=true;
    });
    try{
      UserCredential userdetails =await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.text,password: password.text);
      User? usercreds=userdetails.user;
      if(usercreds!=null){
        if(usercreds.emailVerified){
          setState(() {
            _isLoading=!_isLoading;
          });
          String? email=usercreds.email;
          final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("UserDetails").doc(email).get();
          print(documentSnapshot.data());
          print('$email-exists');
          print(documentSnapshot.exists);
        if(documentSnapshot.exists){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
        }
        else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DetailsPage()));
        }
        }
        else{
          await usercreds.sendEmailVerification();
          setState(() {
            _isLoading=!_isLoading;
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please complete your Email verification'),
          ));
          });
        }
      }
    }
    catch(e){
      print('Error 1');
      setState(() {
        _isLoading=!_isLoading;
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please check your credentials.'),
        ),
      );
      });
    }
  }


  Future<bool> reset(BuildContext context,TextEditingController mail)async{
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    user.dispose();
    password.dispose();
    mail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Center(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Padding(
                          padding: const EdgeInsets.only(top:50.0,bottom: 50),
                          child: Text(
                            'Trash Track',
                            style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'Dancing_Script',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                            
                        Container(
                          height: 150,
                          width: 350,
                          child: Image.asset('assets/gifs/recycle.gif'),
                        ),
                        // SizedBox(height: 30,width: 30,),
                        
                        if(_isLoading)
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1,sigmaY: 1),
                            child: Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(), // Circular loading indicator
                                          Image.asset(
                                            'assets/gifs/load.gif', // Path to your GIF image
                                            width: 80, // Adjust the width of the GIF
                                          ),    
                                        ],
                                        ), 
                                      )
                                    ),
                              ),
                            
                          Padding(
                            padding: const EdgeInsets.only(top:20.0,bottom: 10,left: 20,right: 20),
                            child: TextField(
                              controller: user,
                              decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 73, 72, 72),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              
                            ))),
                          ),
                                      
                          Padding(
                            padding: const EdgeInsets.only(top:20.0,bottom: 10,left: 20,right: 20),
                            child: TextField(
                              obscureText:hide ,
                              controller: password,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIconColor: const Color.fromARGB(96, 61, 60, 60),
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  hide=!hide;
                                });
                              },
                              child: Icon(!hide ? Icons.visibility : Icons.visibility_off)),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 73, 72, 72),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ))),
                          ),
                            
                          Padding(
                            padding: const EdgeInsets.only(right:20.0),
                            child: GestureDetector(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final screenHeight = MediaQuery.of(context).size.height;
                                    final halfScreenHeight = (screenHeight / 2)-100;
                                    return Center(
                                      child: Container(
                                        height: halfScreenHeight,
                                        child: AlertDialog(
                                        title: Text('Forgot Password'),
                                        content: Column(
                                          children: [
                                            txtfld(mail, "Enter Email"),
                                                                  
                                            ElevatedButton(
                                              onPressed: ()async{
                                                setState(() {
                                                  _isLoading=!_isLoading;
                                                });
                                                reset(context,mail);
                                                
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
                                    );
                                  },
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forget Password?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                            
                          SizedBox(height: 20,),
                            
                          Padding(
                            padding: const EdgeInsets.only(right:20.0,left: 20),
                            child: IgnorePointer(
                              ignoring: _isLoading,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: (){
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                    setState(() {
                                      _isLoading=!_isLoading;
                                    });
                                    signin();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: Text('LogIn',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),)
                                  ),
                              ),
                            ),
                          ),

                          createacc(),

                          Padding(
                            padding: const EdgeInsets.only(right:20.0,left: 20),
                            child: IgnorePointer(
                              ignoring: _isLoading,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sign_Up()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: Text('SignUp',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),)
                                  ),
                              ),
                            ),
                          ),
                          
                          if(_isLoading)
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1,sigmaY: 1),
                            child: Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                  child:Text('') 
                                  )
                                ),
                          ),
                        
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget createacc(){
  return Container(
    child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5,left:5),
                    child: Text('Don\'t have an Account?',style: TextStyle(fontSize: 10,color: const Color.fromARGB(255, 95, 92, 92)),),
                  ),
                  Expanded(
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                ],
              ),
            ),
  );
}

// Widget forgotpass(BuildContext context,String mail,bool ){
//   final screenHeight = MediaQuery.of(context).size.height;
//     final halfScreenHeight = screenHeight / 2;
//   return Center(
//       child: SizedBox(
//         height: halfScreenHeight,
//         child: 
//       ),
//     );
// }
