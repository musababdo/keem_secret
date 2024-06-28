
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/local/local.dart';
import 'package:panorama_home/local/local_controller.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/choose_lang.dart';
import 'package:panorama_home/screens/details.dart';
import 'package:panorama_home/screens/home.dart';
import 'package:panorama_home/screens/info.dart';
import 'package:panorama_home/screens/tabby_page/chechout_page.dart';
import 'package:provider/provider.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
   Stripe.publishableKey = publishkey;
   await Stripe.instance.applySettings();
  TabbySDK().setup(
    withApiKey: 'pk_test_4c6faaba-9d7e-43e8-94e2-70143dfe9c83', // Put here your Api key
    // environment: Environment.production, // Or use Environment.stage
  );
  tamara_api;
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MyLocalController c = Get.put(MyLocalController());
    FlutterNativeSplash.remove();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartItem>(
          create: (context) => CartItem(),
        ),
      ],
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ar', ''),
        ],
        //locale:c.intiallang,
        debugShowCheckedModeBanner: false,
          //locale: Get.deviceLocale,
          locale:c.intiallang,
          //locale: Locale("en"),
          translations: MyLocal(),
          //home: Info(),
           //initialRoute:Home.id,
          initialRoute: box.read('show')==1?Home.id:ChooseLang.id,
          // //initialRoute: box.read('start')==1?Myui.id:BoardingHome.id,
          routes: {
            Home.id: (context) => Home(),
            ChooseLang.id: (context) => ChooseLang(),
            TabbyCheckoutNavParams.id: (context) => CheckoutPage(),
            //Myui.id: (context) => Myui(),
            Details.id: (context) => Details(),
          }
      ),
    );
  }
}
