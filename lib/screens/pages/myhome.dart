
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/components/ad.dart';
import 'package:panorama_home/components/carousal.dart';
import 'package:panorama_home/components/category.dart';
import 'package:panorama_home/components/gallery.dart';
import 'package:panorama_home/components/markets.dart';
import 'package:panorama_home/components/newest.dart';
import 'package:panorama_home/components/offer.dart';
import 'package:panorama_home/components/recommend.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/cart_screen.dart';
import 'package:provider/provider.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    List<Product> cproducts=Provider.of<CartItem>(context).products;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Image.asset(
          'assets/images/logo.jpg', // Replace with the path to your image
          height: 60, // Set the height of the image as needed
        ),
        // title: Text('Panorama Home',
        //   style: GoogleFonts.aladin(
        //     textStyle: const TextStyle(
        //         color: Colors.black,
        //         fontSize: 22,
        //         fontWeight: FontWeight.bold
        //     ),
        //   ),),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top:6,right: 10,left: 10),
          child: Stack(
            children: <Widget>[
              GestureDetector(
                child: Image.asset(
                  'assets/images/cart.png', // Replace with the path to your image
                  height: 40, // Set the height of the image as needed
                ),
                onTap: (){
                  Get.to(CartScreen());
                },
              ),
              // IconButton(
              //   icon: Icon(Icons.shopping_cart,
              //   ),
              //   onPressed: (){
              //     Get.to(CartScreen());
              //   },
              // ),
              Padding(
                padding: EdgeInsets.only(left: 20.0,top: 0),
                child: CircleAvatar(
                  radius: 10.0,
                  child: GestureDetector(
                    onTap:(){
                      Get.to(CartScreen());
                    },
                    child: Text(
                      cproducts.length.toString()
                      ,
                      style: TextStyle(fontSize: 15,color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  backgroundColor: Color(0xFFA11B00),
                ),
              )
            ],
          ),
        ),
      ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Category(),
            Carousal(),
            Add(),
            //Markets(),
            Newest(),
            Offer(),
            //Gallery(),
            Recommend(),
          ],
        ),
      ),
    );
  }
}
