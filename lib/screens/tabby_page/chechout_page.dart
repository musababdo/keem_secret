import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/screens/done.dart';
import 'package:panorama_home/screens/info.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

class TabbyCheckoutNavParams {
  static String id='TabbyCheckoutNavParams';
  TabbyCheckoutNavParams({
    required this.selectedProduct,
  });

  final TabbyProduct selectedProduct;
}

class CheckoutPage extends StatefulWidget {
  List<Product> products = [];
  //const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late TabbyProduct selectedProduct;

  void onResult(WebViewResult resultCode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultCode.name),
      ),
    );
    if(resultCode.name=='close'){
      Get.to(Info());
    }else{
      widget.products.clear();
      Get.to(Done());
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)!.settings;
    selectedProduct =
        (settings.arguments as TabbyCheckoutNavParams).selectedProduct;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kMainColor,
        //automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Tabby Checkout',
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              //fontWeight: FontWeight.bold
            ),
          ),),
      ),
      body: TabbyWebView(
        webUrl: selectedProduct.webUrl,
        onResult: onResult,
      ),
    );
  }
}
