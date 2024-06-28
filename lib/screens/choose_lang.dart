
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/local/local_controller.dart';
import 'package:panorama_home/screens/home.dart';

class ChooseLang extends StatefulWidget {
  static String id='chooselang';
  @override
  State<ChooseLang> createState() => _ChooseLangState();
}

class _ChooseLangState extends State<ChooseLang> {
  @override
  Widget build(BuildContext context) {
    MyLocalController controller = Get.find();
    return SafeArea(
      child: WillPopScope(
        onWillPop:(){
          SystemNavigator.pop();
          //Get.back();
          return Future.value(false);
        },
        child: Scaffold(
          body:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('choose_lang'.tr,
                  style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          controller.changeLang("en");
                          box.write('show',1);
                          Get.to(Home());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kMainColor, // Background color
                      ),
                      child: Text("English"),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          controller.changeLang("ar");
                          box.write('show',1);
                          Get.to(Home());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kMainColor, // Background color
                      ),
                      child: Text("عربي"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
