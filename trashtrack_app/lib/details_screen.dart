import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'stuffs.dart';
import 'firebase_storage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'globalvariables.dart';


class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();
  TextEditingController flat = TextEditingController();
  TextEditingController phone = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = GlobalKey();
  String cityval='';
  String streetval='';
  List<String> districts =['Tirupur','Coimbatore','Chennai','Erode','Karur'];
  Map<String,List<String>> streets={'Tirupur':['Cheran Nagar','Jai Nagar','kathirvel Colony'],'Coimbatore':['Gandhipuran','Ukkadam','Sulur']};


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    fname.dispose();
    lname.dispose();
    flat.dispose();
    phone.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right:20.0,left: 20,top: 5,bottom: 10),
          child: Column(
            children: [

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

              txtfld(fname, 'First Name'),

              txtfld(lname, 'Last Name'),

              txtfld(phone, 'Phone'),

              txtfld(flat, 'Flat.No'),
              
              Padding(
                padding: const EdgeInsets.only(top:8.0,right: 20,left: 20,bottom:8 ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Add a border
                    borderRadius: BorderRadius.circular(10), // Add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0,right: 8,left:8),
                    child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                            showSelectedItems: true,
                            // disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        items:districts,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                labelText: "City",
                                hintText: "City",
                            ),
                        ),
                        onChanged: (item){
                          setState(() {
                            cityval='$item';
                          });
                        },
                        selectedItem: cityval,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:8.0,right: 20,left: 20,bottom:8 ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Add a border
                    borderRadius: BorderRadius.circular(10), // Add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0,right: 8,left:8),
                    child: DropdownSearch<String>(
                        popupProps: PopupProps.menu( 
                          // menuProps: maxh,
                            showSelectedItems: true,
                        ),
                        items:streets[cityval]??[],
                        dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                labelText: "Street",
                                hintText: "Street",
                            ),
                        ),
                        onChanged: (item){
                          setState(() {
                            streetval='$item';
                          });
                        },
                        selectedItem: streetval,
                    ),
                  ),
                ),
              ),
              

              Padding(
                padding: const EdgeInsets.only(top:90.0,left: 210),
                child: Row(
                  children: [
                    
                    TextButton(
                          onPressed: (){
                            String? email=user?.email ?? 'No Email Available';
                            adduser userdetails = adduser(fname, lname, flat, streetval, cityval,email,phone);
                            validate valid=validate(fname,lname,flat, streetval, cityval,phone);
                            if(valid.empty()){
                              showsnackbar(context, 'Fill all fields', 2);
                            }
                            else if(!valid.phonechk()){
                              showsnackbar(context, 'Enter valid phone', 2);
                            }
                            else if(userdetails.adduser1(context)){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(email: email,)));
                            }
                            else{
                              showsnackbar(context, 'Error Occurred.Try again later', 2);
                            }
                          },
                          child: Text('Finish',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue,
                            ),
                          )
                          ),
                          Icon(Icons.arrow_right_alt_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class validate{
  final TextEditingController fname;
  final TextEditingController lname;
  final TextEditingController phone;
  final TextEditingController flat;
  final String street;
  final String city;
  validate(this.fname,this.lname,this.flat,this.street,this.city,this.phone);

  bool empty(){
    return (flat.text.isEmpty|| street.isEmpty || city.isEmpty || fname.text.isEmpty||lname.text.isEmpty);
  }

  bool phonechk(){
    if(phone.text.length<10 || phone.text.length>10){
      return false;
    }
    return true;
  }
}

 

  
