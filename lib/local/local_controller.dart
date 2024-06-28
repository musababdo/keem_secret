
import 'package:panorama_home/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLocalController extends GetxController{

  //Locale intiallang = sharedpref!.getString("lang")=="ar"?Get.deviceLocale!:Locale(sharedpref!.getString("lang")!);

  Locale intiallang =box.read('lang')=="ar"?Locale("ar"):Locale("en");

  void changeLang(String codelang){
    Locale locale = Locale(codelang);
    //sharedpref!.setString("lang",codelang);
    //box.write('mylang',codelang);
    box.write('lang',codelang);
    Get.updateLocale(locale);
  }

}