
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/local/local_controller.dart';
import 'package:panorama_home/screens/login.dart';
import 'package:panorama_home/screens/register.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  int? value;
  String? name;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = box.read('value');
    name = box.read('username');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                value != 1?
                Column(
                  children: [
                    Text(
                      "home_welcome".tr,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: kMainColor
                      ),
                    ),),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 14,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(Register());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: kMainColor,
                              ),
                              child: Text(
                                "register_btn".tr,style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 17,
                                ),
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8.0),
                            height: MediaQuery.of(context).size.height / 14,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(Login());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: kMainColor,
                              ),
                              child: Text(
                                "login_btn".tr,style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 17,
                                ),
                              ),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ):
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      name!,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                      ),
                    ),),
                    SizedBox(width: 10,),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Image.asset(
                        'assets/images/man.png',
                        width: 60,
                        height: 60,
                      ),
                      radius: 50,
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Divider(),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.arrow_forward_ios,size: 16,),
                    title: Text("change_lang".tr, style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 16
                      ),
                    ),
                    ),
                    leading: Icon(Icons.g_translate,color: kMainColor,),
                    onTap: (){
                      chooseLang();
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward_ios,size: 16,),
                    title: Text("call_us".tr, style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 16
                      ),
                    ),),
                    leading: Icon(Icons.call,color: kMainColor),
                    onTap: (){
                      //Get.to(Location());
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward_ios,size: 16,),
                    title: Text("contact_us".tr, style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 16
                      ),
                    ),),
                    leading: Icon(Icons.email_outlined,color: kMainColor),
                    onTap: (){
                      //Get.to(Location());
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    trailing: Icon(Icons.arrow_forward_ios,size: 16,),
                    title: Text("tirm".tr, style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 16
                      ),
                    ),),
                    leading: Icon(Icons.assignment_outlined,color: kMainColor),
                    onTap: (){
                      //Get.to(Location());
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    dense: true,
                    trailing: Icon(Icons.arrow_forward_ios,size: 16,),
                    title: Text("exit".tr, style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                          fontSize: 16
                      ),
                    ),),
                    leading: Icon(Icons.logout,color: kMainColor),
                    onTap: (){
                      exitDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
  chooseLang(){
    showModalBottomSheet(context: context, builder: (context){
      MyLocalController controller = Get.find();
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
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
                            controller.changeLang("en");
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kMainColor, // Background color
                          ),
                          child: Text("English"),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            controller.changeLang("ar");
                            Navigator.of(context).pop();
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
            )
        ),
      );
    });
  }
  exitDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);

          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("exit".tr,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 20,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('menu_alert_message'.tr,style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('menu_alert_btn_cancel'.tr,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                SystemNavigator.pop();
                              });
                            },
                            child: Text('menu_alert_btn_ok'.tr,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    });
  }
}
