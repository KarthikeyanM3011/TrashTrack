import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'stuffs.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({super.key});

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  bool hide=true;
  bool _isLoading=false;
  TextEditingController user =TextEditingController();
  TextEditingController mail =TextEditingController();
  TextEditingController pass1 =TextEditingController();
  TextEditingController pass2 =TextEditingController();
  TextEditingController contact =TextEditingController();
  bool? _issent;
  
  
  Future<void> Signinemail()async{
    try{
      UserCredential usercredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: mail.text, password: pass1.text);
      await usercredential.user!.sendEmailVerification();
      showsnackbar(context, 'Please verify your Email before Login', 3);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Log_In()));
    }
    catch(error){
      print(error);
      showsnackbar(context, 'Error : $error', 2);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children:[
              Padding(
                  padding: const EdgeInsets.only(top:50.0,bottom: 50),
                  child: const Text(
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

                  txtfld(user, 'User Name'),
                  txtfld(mail, 'Email'),

                    Padding(
                      padding: const EdgeInsets.only(top:20.0,bottom: 5,left: 20,right: 20),
                      child: TextField(
                        controller: pass1,
                        decoration: InputDecoration(
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
                      padding: const EdgeInsets.only(top:20.0,bottom: 5,left: 20,right: 20),
                      child: TextField(
                        controller: pass2,
                        decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      suffixIconColor: const Color.fromARGB(96, 61, 60, 60),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    hide=!hide;
                                  });
                                },
                                child: Icon(!hide ? Icons.visibility : Icons.visibility_off)),
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 73, 72, 72),
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        
                      ))),
                    ),
      
                    txtfld(contact, 'Phone'),

                    Padding(
                            padding: const EdgeInsets.only(right:20.0,left: 20,bottom: 30,top: 10),
                            child: IgnorePointer(
                              ignoring: _isLoading,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton( 
                                  onPressed: ()async{
                                    print(mail.text);
                                    validate check = validate(pass1,pass2);
                                    emptyfld fld= emptyfld(user, mail, contact);
                                    mailcheck mailformat=mailcheck(mail);
                                    phone chkphone =phone(contact);
                                    
                                    if(fld.checkempty()){
                                      showsnackbar(context, 'Fill all fields',2);
                                    }
                                    else if(! check.check()){
                                      showsnackbar(context, 'Check your passwords\nPassword should contain\n1.Password length should be atleast 6\n2.Atleast 1 integer\n3.Atleast 1 special character\n4.Alteast 3 alphabets\n5.Password should not contain blank space',6);
                                    }
                                    else if(!chkphone.chkphone()){
                                      showsnackbar(context, 'Enter Valid Phone',2);
                                    }
                                    else if(! mailformat.format()){
                                      showsnackbar(context, 'Enter valid Email',2);
                                    }
                                    else{
                                      Signinemail();
                                    }
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
            ]
          )
        ),
      ),
    );
  }
}

class validate{
  final TextEditingController pass1;
  final TextEditingController pass2;
  validate(this.pass1,this.pass2 );
  bool check(){
    if(pass1.text != pass2.text){
      return false;
    }
    if (pass1.text.length < 6) {
    return false;
    }
    if (!pass1.text.contains(RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]'))) {
      return false;
    }
    if (!pass1.text.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    if (pass1.text.replaceAll(RegExp(r'[^a-zA-Z]'), '').length < 3) {
      return false;
    }
    if (pass1.text.contains(' ')) {
      return false;
    }
      return true;
    }
  
}

class phone{
  final TextEditingController contact;
  phone(this.contact);
  bool chkphone(){
    final RegExp regex = RegExp(r'^\d{10}$');
    final number=contact.text;
    print(regex.hasMatch(number));
    print(number);
    print(number.length);
    return (number.length == 10 && regex.hasMatch(number.toString()));
  }
}

class emptyfld{
  final TextEditingController user;
  final TextEditingController mail;
  final TextEditingController phone;

  emptyfld(this.user,this.mail,this.phone);
  bool checkempty(){
    return (user.text.isEmpty || mail.text.isEmpty || phone.text.isEmpty);
  }
}

class mailcheck{
  final TextEditingController mail;
  mailcheck(this.mail);
  bool format(){
     return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(mail.text);
  }
}



