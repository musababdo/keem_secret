
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/screens/home.dart';
import 'package:panorama_home/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;
  String? lang;

  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController _password = TextEditingController();

  Future register() async{
    var url = Uri.parse('${api}register');
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'lang': '$lang',
    };
    final data = {
      "name" : _username.text.trim(),
      "email" : _email.text.trim(),
      "phone" : phone.text.trim(),
      "password" : _password.text.trim(),
    };
    final jsonData = jsonEncode(data);
    var response=await http.post(url,headers: headers,body: jsonData);
    //final jsonresponse = json.decode(response.body);
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  errorDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text('login_invalid'.tr,style: GoogleFonts.cairo(),),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("حسنا",style: GoogleFonts.cairo(),)
              ),
            ],
          );
        }
    );
  }

  passwordDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text('password_incorrect'.tr,style: GoogleFonts.cairo(),),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("ok".tr,style: GoogleFonts.cairo(),)
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = box.read('lang');
  }

  SharedPreferences? preferences;
  saveValue(int value) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences!.setInt("value", value);
    });
  }

  bool _validate = false;
  bool _secureText = true;
  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String? _errorMessage(String hint) {
    if(hint=="login_username".tr){
      return 'login_error'.tr;
    }else if(hint=="email".tr){
      return 'login_error'.tr;
    }else if(hint=="phone".tr){
      return 'login_error'.tr;
    }else if(hint=="login_password".tr){
      return 'login_error'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: WillPopScope(
        onWillPop:(){
          Get.to(Home());
          return Future.value(false);
        },
        child: Container(
          color: kMainColor,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: kMainColor,
              body: Container(
                child: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                        BoxConstraints(minHeight: viewportConstraints.maxHeight),
                        child: Container(
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: kMainColor,
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: Center(
                                    child: Text(
                                      "register_btn".tr,
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        )
                                      )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(30),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _username,
                                          validator:(value) {
                                            if (value!.isEmpty) {
                                              return _errorMessage("login_username".tr);
                                              // ignore: missing_return
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "login_username".tr,
                                            labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Icon(Icons.person,color: kMainColor,),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          controller: _email,
                                          keyboardType: TextInputType.emailAddress,
                                          validator:(value) {
                                            if (value!.isEmpty) {
                                              return _errorMessage("email".tr);
                                              // ignore: missing_return
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "email".tr,
                                            labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Icon(Icons.email,color: kMainColor,),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          controller: phone,
                                          keyboardType: TextInputType.number,
                                          validator:(value) {
                                            if (value!.isEmpty) {
                                              return _errorMessage("phone".tr);
                                              // ignore: missing_return
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText: "phone".tr,
                                            labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Icon(Icons.phone,color: kMainColor,),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          controller: _password,
                                          obscureText: _secureText,
                                          validator:(value) {
                                            if (value!.isEmpty) {
                                              return _errorMessage("login_password".tr);
                                              // ignore: missing_return
                                            }
                                          },
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                              onPressed: showHide,
                                              icon: Icon(_secureText
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                            ),
                                            labelText: "login_password".tr,
                                            labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(13),
                                            ),
                                            prefixIcon: IconTheme(
                                              data: IconThemeData(
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Icon(Icons.lock,color: kMainColor,),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                                          child: Builder(
                                            builder: (context) => ElevatedButton(
                                              onPressed: () {
                                                if (_state == 0) {
                                                  animateButton();
                                                }

                                                if (_globalKey.currentState!.validate()){
                                                  _globalKey.currentState!.save();
                                                  try{
                                                     String password = _password.text;
                                                    if (password.length < 6) {
                                                      passwordDialog();
                                                    }else{
                                                      register();
                                                      Fluttertoast.showToast(
                                                          msg: "save_successfully".tr,
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.black,
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                      Get.to(Login());
                                                    }
                                                  }on PlatformException catch(e){

                                                  }
                                                }else{
                                                  setState(() {
                                                    _state = 0;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: kMainColor,
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
                                                child: Center(
                                                    child:setUpButtonChild()
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'have_account'.tr,
                                              style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,fontSize: 14
                                                  )
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: () {
                                                Get.to(Login());
                                              },
                                              child: Text(
                                                'login_btn'.tr,
                                                style: GoogleFonts.cairo(
                                                    textStyle: TextStyle(
                                                        color: kMainColor,fontSize: 15
                                                    )
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget? setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "register_btn".tr,
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }
}
