
 import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/home.dart';
import 'package:panorama_home/screens/info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {

  List<Product> products = [];

   @override
   State<CartScreen> createState() => _CartScreenState();
 }

 class _CartScreenState extends State<CartScreen> {

   int? value;
   String? myimage;
   final formatter = new NumberFormat("###,###");

   int _currentIndex = 0;
   var mylength=[];

   List<Widget> _buildIndicators() {
     return List<Widget>.generate(mylength.length, (index) {
       return Container(
         width: 8,
         height: 8,
         margin: EdgeInsets.symmetric(horizontal: 4),
         decoration: BoxDecoration(
           shape: BoxShape.circle,
           color: _currentIndex == index ? kMainColor : Colors.grey,
         ),
       );
     });
   }

   saveData(double price ) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     setState(() {
       preferences.setDouble("price", price);
       preferences.commit();
     });
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myimage = box.read('myimage');
  }

   @override
   Widget build(BuildContext context) {
     widget.products=Provider.of<CartItem>(context).products;
     final double screenHeight = MediaQuery.of(context).size.height;
     final double screenWidth = MediaQuery.of(context).size.width;
     final double appBarHeight = AppBar().preferredSize.height;
     final double statusBarHeight = MediaQuery.of(context).padding.top;
     return Container(
       color: Colors.white,
       child: SafeArea(
         child: WillPopScope(
           onWillPop:(){
             Get.to(Home());
             //Get.back();
             return Future.value(false);
           },
           child: Scaffold(
             appBar: AppBar(
               backgroundColor: Colors.transparent,
               //automaticallyImplyLeading: false,
               elevation: 0,
               centerTitle: true,
               iconTheme: IconThemeData(
                 color: Colors.black,
               ),
               title: Text('home_cart'.tr,
                 style: GoogleFonts.cairo(
                   textStyle: TextStyle(color: Colors.black),),),
               actions: <Widget>[
                 IconButton(
                   icon: Icon(Icons.delete,
                   ),
                   onPressed: (){
                     if(widget.products.map((e) => jsonEncode(e.toJson())).toList().isEmpty){
                       Fluttertoast.showToast(
                           msg: "cart_empty".tr,
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.CENTER,
                           timeInSecForIosWeb: 1,
                           backgroundColor: Colors.black,
                           textColor: Colors.white,
                           fontSize: 16.0
                       );
                     }else{
                       deleteDialog();
                     }
                   },
                 )
               ],
             ),
             backgroundColor: Colors.white,
             persistentFooterButtons: <Widget>[
               Builder(
                 builder: (context) => ButtonTheme(
                   minWidth: screenWidth,
                   height: screenHeight * .04,
                   child: MaterialButton(
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.all(Radius.circular(10))),
                     onPressed: () {
                       if(widget.products.map((e) => jsonEncode(e.toJson())).toList().isEmpty){
                         Fluttertoast.showToast(
                             msg: "cart_empty".tr,
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             backgroundColor: Colors.black,
                             textColor: Colors.white,
                             fontSize: 16.0
                         );
                       }else{
                         checkOutDialog();
                       }
                     },
                     child: Padding(
                       padding: const EdgeInsets.only(top: 5,bottom: 5),
                       child: Text('checkout'.tr,
                         style: GoogleFonts.cairo(
                           textStyle: TextStyle(
                             fontSize: 18,
                             color: Colors.white
                           ),
                         ),
                       ),
                     ),
                     color: kMainColor,
                   ),
                 ),
               ),
             ],
             body: SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child: Padding(
                 padding: const EdgeInsets.only(bottom: 20),
                 child: Column(
                   children: <Widget>[
                     LayoutBuilder(builder: (context, constrains) {
                       if (widget.products.isNotEmpty) {
                         return Container(
                           height: screenHeight -
                               statusBarHeight -
                               appBarHeight -
                               (screenHeight * .08),
                           child: ListView.builder(
                             itemBuilder: (context, index) {
                               /*for(var i = 0; i < products.length; i++){
                                  mylist.add(products[i]);
                                }
                                print(mylist.length);*/
                               box.write('total', getTotallPrice(widget.products));
                               box.write('total_quant', getTotallQuantity(widget.products));
                               saveData(getTotallPrice(widget.products));
                               return Padding(
                                 padding: const EdgeInsets.only(top: 0,bottom: 10,right: 7,left:7),
                                 child: Card(
                                   shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(13)
                                   ),
                                   elevation: 1,
                                   child: Container(
                                     height: screenHeight / 5,
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: <Widget>[
                                           Row(
                                             children: [
                                               Container(
                                                 width:MediaQuery.of(context).size.width / 3,
                                                 //width: 150.0,
                                                 //height: 150.0,
                                                 decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(13),
                                                   image: DecorationImage(
                                                     image: widget.products[index].myimage.isEmpty?
                                                     NetworkImage(widget.products[index].image!):
                                                     NetworkImage(widget.products[index].myimage),
                                                     fit: BoxFit.cover,
                                                     //opacity: 0.7,
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(width: 5,),
                                               Column(
                                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   SizedBox(
                                                     width: MediaQuery.of(context).size.width / 2.5,
                                                     child: Text(
                                                       widget.products[index].name!,
                                                       overflow: TextOverflow.ellipsis,
                                                       maxLines: 3,
                                                       style: GoogleFonts.cairo(
                                                         textStyle: TextStyle(
                                                             fontSize: 11,
                                                             fontWeight: FontWeight.bold
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       widget.products[index].discount==0?
                                                       Text(
                                                         '${widget.products[index].price!}',
                                                         style: GoogleFonts.cairo(
                                                           textStyle: TextStyle(
                                                               fontSize: 18
                                                           ),
                                                         ),
                                                       ):
                                                       Text(
                                                         '${widget.products[index].discount!}',
                                                         style: GoogleFonts.cairo(
                                                           textStyle: TextStyle(
                                                               fontSize: 18
                                                           ),
                                                         ),
                                                       ),
                                                       SizedBox(width: 5,),
                                                       Text(
                                                         'price'.tr,
                                                         style: GoogleFonts.cairo(
                                                           textStyle: TextStyle(
                                                               fontSize: 18,
                                                               color: kMainColor,
                                                               fontWeight:FontWeight.bold
                                                           ),
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                   Container(
                                                     height: 40,
                                                     width: 90,
                                                     padding: EdgeInsets.all(5),
                                                     decoration: BoxDecoration(
                                                       color: kMainColor,
                                                       borderRadius: BorderRadius.circular(10),
                                                     ),
                                                     child: Row(
                                                       mainAxisAlignment:
                                                       MainAxisAlignment.spaceBetween,
                                                       children: [
                                                         GestureDetector(
                                                           onTap: (){
                                                             setState(() {
                                                               if (widget.products[index].quantity > 1) {
                                                                 widget.products[index].quantity--;
                                                               }
                                                             });
                                                           },
                                                           child: Icon(
                                                             Icons.remove,
                                                             color: Colors.white,
                                                             size: 20,
                                                           ),
                                                         ),
                                                         Text(
                                                           widget.products[index].quantity.toString(),
                                                           style: TextStyle(
                                                             fontSize: 16,
                                                             color: Colors.white,
                                                           ),
                                                         ),
                                                         GestureDetector(
                                                           onTap: (){
                                                             setState(() {
                                                               widget.products[index].quantity++;
                                                             });
                                                           },
                                                           child: Icon(
                                                             Icons.add,
                                                             color: Colors.white,
                                                             size: 20,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ],
                                           ),
                                           Padding(
                                               padding: EdgeInsets.only(top:85),
                                               child: GestureDetector(
                                                   onTap: (){
                                                     Provider.of<CartItem>(context, listen: false)
                                                         .deleteProduct(widget.products[index]);
                                                   },
                                                 child: Container(
                                                   //width:MediaQuery.of(context).size.width / 3,
                                                   width: 45.0,
                                                   height: 80.0,
                                                   decoration: BoxDecoration(
                                                     color: kMainColor,
                                                     borderRadius: BorderRadius.circular(13),
                                                   ),
                                                     child: Icon(Icons.delete,color: Colors.white,)
                                                 ),
                                               )
                                           ),
                                         ],
                                       ),
                                     ),
                                     //color: kSecondaryColor,
                                   ),
                                 ),
                               );
                             },
                             itemCount: widget.products.length,
                           ),
                         );
                       } else {
                         return Container(
                           height: screenHeight -
                               (screenHeight * .09) -
                               appBarHeight -
                               statusBarHeight,
                           child: Padding(
                             padding: const EdgeInsets.only(right: 12,left: 12),
                             child: Center(
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Image.asset(
                                         'assets/images/empty_cart.png',
                                         width: MediaQuery.of(context).size.width,
                                         height: MediaQuery.of(context).size.height / 4,),
                                     SizedBox(height: 10,),
                                     Text('cart_empty'.tr,
                                       style: GoogleFonts.cairo(
                                         textStyle: TextStyle(
                                           fontSize: 25,
                                         ),
                                       ),
                                     ),
                                     SizedBox(height: 10,),
                                     GestureDetector(
                                       onTap:(){
                                         Get.to(Home());
                                       },
                                       child: Container(
                                         decoration: BoxDecoration(
                                           color: kMainColor,
                                           borderRadius: BorderRadius.all(
                                             Radius.circular(12),
                                           ),
                                         ),
                                         child:Padding(
                                           padding: const EdgeInsets.only(top: 8,bottom: 8),
                                           child: Center(
                                             child: Text(
                                               "shope_now".tr,
                                               style: GoogleFonts.cairo(
                                                 textStyle: TextStyle(
                                                   fontSize: 18,
                                                   color: Colors.white,
                                                 ),
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 )
                             ),
                           ),
                         );
                       }
                     },
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
       ),
     );
   }
   deleteDialog(){
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
                     Text("profile_dialog_title".tr,style: GoogleFonts.cairo(
                       textStyle: TextStyle(
                         fontSize: 22,
                       ),
                     ),),
                     const SizedBox(height:8),
                     Text('profile_dialog_delete'.tr,style: GoogleFonts.cairo(
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
                             child: Text('profile_dialog_no'.tr,
                               style: GoogleFonts.cairo(
                                 textStyle: TextStyle(
                                   fontSize: 20,
                                 ),
                               ),
                             ),
                           ),
                           MaterialButton(
                             onPressed: () {
                               setState(() {
                                 Provider.of<CartItem>(context, listen: false).deleteAll();
                                 Navigator.of(context).pop();
                               });
                             },
                             child: Text('profile_dialog_ok'.tr,
                               style: GoogleFonts.cairo(
                                 textStyle: TextStyle(
                                   fontSize: 20,
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
   getTotallPrice(List<Product> products) {
     double price = 0;
     for (var product in products) {
       if(product.discount==0){
         price += (product.quantity * double.parse(product.price!.toString()));
       }else{
         price += (product.quantity * double.parse(product.discount!.toString()));
       }
     }
     return price;
   }
   getTotallQuantity(List<Product> products) {
     double price = 0;
     for (var product in products) {
       price += product.quantity;
     }
     return price;
   }
   myDialog(){
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
                     Text("home_thedialog_title".tr,style: GoogleFonts.cairo(
                       textStyle: TextStyle(
                         fontSize: 22,
                       ),
                     ),),
                     const SizedBox(height:8),
                     Text('home_thedialog_body'.tr,style: GoogleFonts.cairo(
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
                             child: Text('home_thedialog_cancel'.tr,
                               style: GoogleFonts.cairo(
                                 textStyle: TextStyle(
                                   fontSize: 20,
                                 ),
                               ),
                             ),
                           ),
                           MaterialButton(
                             onPressed: () {
                               setState(() {
                                 // Get.to(Myui())!.then((_){
                                 //   Navigator.of(context).pop();
                                 // });
                               });
                             },
                             child: Text('home_thedialog_ok'.tr,
                               style: GoogleFonts.cairo(
                                 textStyle: TextStyle(
                                   fontSize: 20,
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
   checkOutDialog(){
     showModalBottomSheet(context: context, builder: (context){
       final double screenHeight = MediaQuery.of(context).size.height;
       return WillPopScope(
         onWillPop:(){
           Navigator.pop(context);
           return Future.value(false);
         },
         child: SafeArea(
             child: Container(
               color: Color(0xFF737373),
               height: screenHeight / 3.5,
               child: Container(
                 decoration: BoxDecoration(
                   color: Theme.of(context).canvasColor,
                   borderRadius: BorderRadius.only(
                     topLeft: const Radius.circular(20),
                     topRight: const Radius.circular(20),
                   ),
                 ),
                 child: Padding(
                   padding: const EdgeInsets.only(right: 10,left: 10,top: 15),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Text('sub_total'.tr,
                             style: GoogleFonts.cairo(
                               textStyle: TextStyle(
                                 fontSize: 20,
                               ),
                             ),
                           ),
                           Row(
                             children: [
                               Text('${getTotallPrice(widget.products).round()}',
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                     fontSize: 20,
                                   ),
                                 ),
                               ),
                               SizedBox(width: 5,),
                               Text(
                                 'price'.tr,
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                       fontSize: 15,
                                       color: Colors.black
                                   ),
                                 ),
                               ),
                             ],
                           ),

                         ],
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Text('shipping'.tr,
                             style: GoogleFonts.cairo(
                               textStyle: TextStyle(
                                 fontSize: 20,
                               ),
                             ),
                           ),
                           Row(
                             children: [
                               Text('25',
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                     fontSize: 20,
                                   ),
                                 ),
                               ),
                               SizedBox(width: 5,),
                               Text(
                                 'price'.tr,
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                       fontSize: 15,
                                       color: Colors.black
                                   ),
                                 ),
                               ),
                             ],
                           ),

                         ],
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Text('total'.tr,
                             style: GoogleFonts.cairo(
                               textStyle: TextStyle(
                                 fontSize: 20,
                               ),
                             ),
                           ),
                           Row(
                             children: [
                               widget.products.isNotEmpty?
                               Text('${getTotallPrice(widget.products).round()+25}',
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                     fontSize: 20,
                                   ),
                                 ),
                               ):Text('0',
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                     fontSize: 20,
                                   ),
                                 ),
                               ),
                               SizedBox(width: 5,),
                               Text(
                                 'price'.tr,
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                       fontSize: 15,
                                       color: Colors.black
                                   ),
                                 ),
                               ),
                             ],
                           ),

                         ],
                       ),
                       Builder(
                         builder: (context) => ButtonTheme(
                           minWidth: MediaQuery.of(context).size.width,
                           height: screenHeight * .04,
                           child: MaterialButton(
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(10))),
                             onPressed: () {
                               if(widget.products.map((e) => jsonEncode(e.toJson())).toList().isEmpty){
                                 Fluttertoast.showToast(
                                     msg: "cart_empty".tr,
                                     toastLength: Toast.LENGTH_SHORT,
                                     gravity: ToastGravity.CENTER,
                                     timeInSecForIosWeb: 1,
                                     backgroundColor: Colors.black,
                                     textColor: Colors.white,
                                     fontSize: 16.0
                                 );
                               }else {
                                 //box.read('value')==1?Get.to(Info()):myDialog();
                                 Get.to(Info());
                                 //widget.products.clear();
                               }
                             },
                             child: Padding(
                               padding: const EdgeInsets.only(top: 5,bottom: 5),
                               child: Text('next'.tr,
                                 style: GoogleFonts.cairo(
                                   textStyle: TextStyle(
                                       fontSize: 18,
                                       color: Colors.white
                                   ),
                                 ),
                               ),
                             ),
                             color: kMainColor,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
             )
         ),
       );
     });
   }
 }
