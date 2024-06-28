
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/components/ad.dart';
import 'package:panorama_home/components/carousal.dart';
import 'package:panorama_home/components/category.dart';
import 'package:panorama_home/components/markets.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/screens/cart_screen.dart';
import 'package:panorama_home/screens/pages/categories.dart';
import 'package:panorama_home/screens/pages/myhome.dart';
import 'package:panorama_home/screens/pages/orders.dart';
import 'package:panorama_home/screens/pages/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static String id='home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  final List<Widget> _children = [
    MyHome(),
    Categories(),
    Orders(),
    Settings(),
  ];
  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: kMainColor,
      child: SafeArea(
        child: WillPopScope(
          onWillPop:(){
            exitDialog();
            return Future.value(false);
          },
          child: Scaffold(
            body: _children[selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black38,
              showUnselectedLabels: true,
              //unselectedLabelStyle: TextStyle(color: Colors.black),
              selectedItemColor: kMainColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home_title'.tr,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'category'.tr,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket),
                  label: 'home_order'.tr,
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'home_settings'.tr,
                  backgroundColor: Colors.white,
                ),
              ],
              currentIndex: selectedIndex,
              onTap: (int x) {
                setState(() {
                  onTabTapped(x);
                });
              },
            ),
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: kMainColor,
            //       borderRadius: BorderRadius.all(Radius.circular(26)),
            //     ),
            //     child: SalomonBottomBar(
            //       unselectedItemColor: Colors.white,
            //       selectedItemColor: Colors.white,
            //       itemPadding: const EdgeInsets.all(12),
            //       margin:
            //       const EdgeInsets.only(left: 20, right: 20, top: 7, bottom: 7),
            //       currentIndex: selectedIndex,
            //       onTap: (int x) {
            //         setState(() {
            //           onTabTapped(x);
            //         });
            //       },
            //       items: [
            //         SalomonBottomBarItem(
            //           icon: Icon(Icons.home),
            //           title: Text("home_title".tr,style: GoogleFonts.cairo()),
            //         ),
            //         SalomonBottomBarItem(
            //           icon: Icon(Icons.category),
            //           title: Text("category".tr,style: GoogleFonts.cairo()),
            //         ),
            //         SalomonBottomBarItem(
            //           icon: Icon(Icons.shopping_basket),
            //           title: Text("home_order".tr,style: GoogleFonts.cairo()),
            //         ),
            //         SalomonBottomBarItem(
            //           icon: Icon(Icons.settings),
            //           title: Text("home_settings".tr,style: GoogleFonts.cairo()),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
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
