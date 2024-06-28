
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/screens/home.dart';

class Done extends StatefulWidget {
  const Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kMainColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: kMainColor,
          body: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 1.6,
              width:double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.check,size: 80,),
                    radius: 85,
                  ),
                  SizedBox(height: 25,),
                  Text(
                    "Order Confirmed".tr,style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    "Thank you for choosing our product.".tr,style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 19,
                        color: kOpenColor
                    ),
                  ),
                  ),
                  SizedBox(height: 50,),
                  GestureDetector(
                    onTap:(){
                      //Get.to(Home());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child:  Center(
                        child: Text(
                          "Go to Home".tr,
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: kMainColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  GestureDetector(
                    onTap:(){
                      SystemNavigator.pop();
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          child:Center(
                            child: Text(
                              "Exit".tr,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
