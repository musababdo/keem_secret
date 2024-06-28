
import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/cart_screen.dart';
import 'package:panorama_home/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_banners/super_banners.dart';
import 'package:http/http.dart' as http;

class Details extends StatefulWidget {
  static String id = 'details';
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  GlobalKey<RefreshIndicatorState> refreshKey =
  GlobalKey<RefreshIndicatorState>();

  String? id,name,image,price,total_price,info,discount;
  int _quantity = 1, qu_index = 1, img_id = 0,check = 0;
  int? value,main_id;
  String? size,color,sizeItem,colorItem;
  final formatter = new NumberFormat("###,###");
  Product? product;
  int _currentIndex = 0;
  int selectedSizeItemIndex = -1;
  int selectedColorItemIndex = -1;
  int selectedImageItemIndex = -1;
  String myimage = '0';
  String first_image = '';
  List<Map<String, dynamic>> keyValueList = [];
  bool exist = false;
  bool img_exist = false;
  List<Product> myproducts = [];

  Future<void> _refresh() async {
    await Future.delayed(Duration(microseconds: 1));
  }

  void _handleButtonClick() {
    refreshKey.currentState?.show();
  }

  // List<Widget> _buildIndicators() {
  //   return List<Widget>.generate(product!.image.length, (index) {
  //     return Container(
  //       width: 8,
  //       height: 8,
  //       margin: EdgeInsets.symmetric(horizontal: 4),
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: _currentIndex == index ? kMainColor : Colors.grey,
  //       ),
  //     );
  //   });
  // }

  SharedPreferences? preferences;
  Future getValue() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        //Navigator.pushNamed(context, PersonInfo.id);
      }else{
        myDialog();
      }
    });
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

  saveData(int price ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("price", price);
      preferences.commit();
    });
  }

  String? lang;
  var images=[];
  Future getImages() async{
    var url = Uri.parse('${api}products_images_by_mainProduct_id/$main_id');
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'lang': '$lang',
    };
    var response = await http.get(url,headers: headers);
    final jsonresponse = json.decode(response.body);
    // for(int i=0;i<=5;i++){
    //   images.add(jsonresponse['products_images'][i]['image']);
    // }
    // print('*********************');
    // print(images);
    // print('*********************');
    return jsonresponse['products_images'];
  }
  Future getGallery() async{
    var url = Uri.parse('${api}products');
    // final Map<String, String> headers = {
    //   'Authorization': 'Bearer $token',
    //   'lang': '$lang',
    //   'Accept': 'application/json',
    // };
    var response = await http.post(url);
    final jsonresponse = json.decode(response.body);
    // print('*********************');
    // print(jsonresponse['data']['products'][0]['info']);
    // print('*********************');
    return jsonresponse['products'];
  }
 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   lang = box.read('lang');
   main_id = box.read('main_id');

   id = box.read('index_id');
   name = box.read('index_name');
   image = box.read('index_image');
   price = box.read('index_price');
   total_price = box.read('index_total_price');
   info = box.read('index_description');
   discount = box.read('index_discount');

   getImages();
   getGallery();
   //images = box.read('imgs');
   //images = box.read('imgs');
   // print('/////////////////////');
   // print(images);
   // print('/////////////////////');
 }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    product = ModalRoute.of(context)!.settings.arguments as Product?;
    List<Product> cproducts=Provider.of<CartItem>(context).products;
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
        body:RefreshIndicator(
          key: refreshKey,
          onRefresh: _refresh,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 120,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Icon(Icons.arrow_back,color: Colors.black),
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap:(){
                        Get.to(CartScreen());
                      },
                      child: ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        ),
                      ),
                    )
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                          ),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start ,
                            children: [
                              Expanded(
                                child: FutureBuilder(
                                  future: getImages(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) print(snapshot.error);
                                    try {
                                      return snapshot.hasData ?
                                      ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (context, index) {
                                            //List list = snapshot.data;
                                            // print('*********************');
                                            // print(snapshot.data[index]['image']);
                                            // print('*********************');
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedImageItemIndex = index;
                                                  _currentIndex = selectedImageItemIndex;
                                                  myimage = '${api_image}media/products/'+snapshot.data[index]['image'];
                                                  //images.add('${api_image}media/products/'+snapshot.data[index]['image']);
                                                  first_image = index.toString();
                                                  //qu_index = index;
                                                  img_id = snapshot.data[index]['id'];
                                                  //product!.id = img_id.toString();
                                                  //sizeItem = product!.thesize[index];
                                                  print('***************');
                                                  print(img_id);
                                                  print('***************');
                                                });
                                              },
                                              child:selectedImageItemIndex != index ?
                                              Container(
                                                //width: MediaQuery.of(context).size.width / 4,
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                //padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey[300]!),

                                                ),
                                                child: FadeInImage.assetNetwork(
                                                  image: '${api_image}media/products/'+snapshot.data[index]['image'],
                                                  placeholder: 'assets/images/place.png',
                                                  //width: MediaQuery.of(context).size.width / 3,
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/place.png',
                                                        width: MediaQuery.of(context).size.width / 3,
                                                        fit: BoxFit.contain);
                                                  },
                                                  fit: BoxFit.contain,
                                                ),

                                                // Image.network(
                                                //   product!.image[index],
                                                //   fit: BoxFit.contain,
                                                // ),
                                              ):
                                              Container(
                                                //width: MediaQuery.of(context).size.width / 4,
                                                margin: EdgeInsets.symmetric(horizontal: 10),
                                                //padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: kMainColor),
                                                  // borderRadius: BorderRadius.only(
                                                  //   bottomRight: Radius.circular(15.0),
                                                  //   topLeft: Radius.circular(15.0),
                                                  //   bottomLeft: Radius.circular(15.0),
                                                  //   topRight: Radius.circular(15.0),
                                                  // ),
                                                ),
                                                child: FadeInImage.assetNetwork(
                                                  image: '${api_image}media/products/'+snapshot.data[index]['image'],
                                                  placeholder: 'assets/images/place.png',
                                                  //width: MediaQuery.of(context).size.width / 3,
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/place.png',
                                                        width: MediaQuery.of(context).size.width / 3,
                                                        fit: BoxFit.contain);
                                                  },
                                                  fit: BoxFit.cover,
                                                ),
                                                // Image.network(
                                                //   product!.image[index],
                                                //   fit: BoxFit.contain,
                                                // ),
                                              ),
                                            );
                                          })
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: 11,
                                              itemBuilder: (context, index) {
                                                //List list = snapshot.data;
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey,
                                                  highlightColor: Colors.white,
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey,
                                                    highlightColor: Colors.white,
                                                    child: Container(
                                                      //width: MediaQuery.of(context).size.width / 4,
                                                      //margin: EdgeInsets.symmetric(horizontal: 10),
                                                      //padding: EdgeInsets.all(10),
                                                      // decoration: BoxDecoration(
                                                      //   border: Border.all(color: Colors.grey[300]!),
                                                      //
                                                      // ),
                                                      child: FadeInImage.assetNetwork(
                                                        image: 'assets/images/myloader.gif',
                                                        placeholder: 'assets/images/myloader.gif',
                                                        //width: MediaQuery.of(context).size.width / 3,
                                                        imageErrorBuilder: (context, error, stackTrace) {
                                                          return Image.asset('assets/images/myloader.gif',
                                                              width: MediaQuery.of(context).size.width / 3,
                                                              fit: BoxFit.contain);
                                                        },
                                                        fit: BoxFit.cover,
                                                      ),

                                                      // Image.network(
                                                      //   product!.image[index],
                                                      //   fit: BoxFit.contain,
                                                      // ),
                                                    ),
                                                  ),
                                                );
                                              }
                                          );
                                    }catch(e){
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
                backgroundColor: Colors.red,
                elevation: 0,
                expandedHeight: 400,
                flexibleSpace: FlexibleSpaceBar(
                  //background: Image.network(product!.image!,width: double.maxFinite,fit: BoxFit.contain,),
                    background:first_image.isNotEmpty?
                    Image.network(myimage.toString(),width: double.maxFinite,fit: BoxFit.cover,):
                    Image.network(product!.image!,fit: BoxFit.cover,)
                    // Stack(
                    //   children: [
                    //     CarouselSlider(
                    //       options: CarouselOptions(
                    //         height: 400,
                    //         autoPlay: false,
                    //         onPageChanged: (index, reason) {
                    //           setState(() {
                    //             _currentIndex = index;
                    //           });
                    //         },
                    //       ),
                    //       items: List.generate(
                    //         product!.image.length,
                    //             (index) => Container(
                    //           width: MediaQuery.of(context).size.width,
                    //           child: Image.network(product!.image[index],
                    //             fit: BoxFit.cover,),
                    //         ),
                    //       ).toList(),
                    //     ),
                    //     Column(
                    //       children: [
                    //         SizedBox(height:screenHeight * .4,),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: _buildIndicators(),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // )
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10,left: 10),
                          child: ExpandableNotifier(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    product!.discount==0 || product!.discount==product!.price?
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        product!.name!,
                                        maxLines: 3,
                                        //overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              color:Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ):
                                    Row(
                                      children: [
                                        lang=='ar'?
                                        CornerBanner(
                                          bannerPosition: CornerBannerPosition.topRight,
                                          bannerColor: kMainColor,
                                          child: Text(
                                            "new".tr,
                                            style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                )
                                            ),),
                                        ):
                                        CornerBanner(
                                          bannerPosition: CornerBannerPosition.topLeft,
                                          bannerColor: kMainColor,
                                          child: Text("offer".tr,
                                            style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                )
                                            ),),
                                        ),
                                        //SizedBox(width: 10,),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: Text(
                                            product!.name!,
                                            maxLines: 3,
                                            //overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                  fontSize: 13,
                                                  color:Colors.black,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    product!.discount==0 || product!.discount==product!.price?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${product!.price!}',
                                          style: GoogleFonts.cairo(
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          'price'.tr,
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ):
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${product!.price!}',
                                              style: GoogleFonts.cairo(
                                                textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: kMainColor,
                                                    decoration: TextDecoration.lineThrough
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              'price'.tr,
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: kMainColor,
                                                    decoration: TextDecoration.lineThrough
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${product!.discount!}',
                                              style: GoogleFonts.cairo(
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              'price'.tr,
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Container(
                                //   height: 90,
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         'available_size'.tr,
                                //         style: GoogleFonts.cairo(
                                //           textStyle: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 16,
                                //             color: Colors.grey[600],
                                //           ),
                                //         ),
                                //       ),
                                //       SizedBox(height: 5,),
                                //       Expanded(
                                //         child: ListView.builder(
                                //         scrollDirection: Axis.horizontal,
                                //         itemCount: product!.thesize.length,
                                //         itemBuilder: (context, index) {
                                //           return InkWell(
                                //             onTap: () {
                                //               setState(() {
                                //                 selectedSizeItemIndex = index;
                                //                 sizeItem = product!.thesize[index];
                                //                 print('***************');
                                //                 print(sizeItem);
                                //                 print('***************');
                                //               });
                                //             },
                                //             child:selectedSizeItemIndex != index ?
                                //             Container(
                                //               width: MediaQuery.of(context).size.width / 4,
                                //               margin: EdgeInsets.symmetric(horizontal: 10),
                                //               padding: EdgeInsets.all(10),
                                //               decoration: BoxDecoration(
                                //                 border: Border.all(color: kMainColor),
                                //                 borderRadius: BorderRadius.only(
                                //                   bottomRight: Radius.circular(15.0),
                                //                   topLeft: Radius.circular(15.0),
                                //                   bottomLeft: Radius.circular(15.0),
                                //                   topRight: Radius.circular(15.0),
                                //                 ),
                                //               ),
                                //               child: Center(
                                //                 child: Text(
                                //                   product!.thesize[index],
                                //                   style: GoogleFonts.cairo(
                                //                       textStyle: TextStyle(
                                //                         fontSize: 18,
                                //                       )
                                //                   ),
                                //                 ),
                                //               ),
                                //             ):
                                //             Container(
                                //               width: MediaQuery.of(context).size.width / 4,
                                //               margin: EdgeInsets.symmetric(horizontal: 10),
                                //               padding: EdgeInsets.all(10),
                                //               decoration: BoxDecoration(
                                //                 color: kMainColor,
                                //                 borderRadius: BorderRadius.only(
                                //                   bottomRight: Radius.circular(15.0),
                                //                   topLeft: Radius.circular(15.0),
                                //                   bottomLeft: Radius.circular(15.0),
                                //                   topRight: Radius.circular(15.0),
                                //                 ),
                                //               ),
                                //               child: Center(
                                //                 child: Text(
                                //                   product!.thesize[index],
                                //                   style: GoogleFonts.cairo(
                                //                       textStyle: TextStyle(
                                //                         color: Colors.white,
                                //                         fontSize: 18,
                                //                       )
                                //                   ),
                                //                 ),
                                //               ),
                                //             ),
                                //           );
                                //         },
                                //       ),)
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(height: 15,),
                                // Container(
                                //   height: 90,
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         'available_color'.tr,
                                //         style: GoogleFonts.cairo(
                                //           textStyle: TextStyle(
                                //             fontWeight: FontWeight.bold,
                                //             fontSize: 16,
                                //             color: Colors.grey[600],
                                //           ),
                                //         ),
                                //       ),
                                //       SizedBox(height: 5,),
                                //       Expanded(
                                //         child: ListView.builder(
                                //           scrollDirection: Axis.horizontal,
                                //           itemCount: product!.thecolor.length,
                                //           itemBuilder: (context, index) {
                                //             return InkWell(
                                //               onTap: () {
                                //                 setState(() {
                                //                   selectedColorItemIndex = index;
                                //                   colorItem = product!.thecolor[index];
                                //                   print('***************');
                                //                   print(colorItem);
                                //                   print('***************');
                                //                 });
                                //               },
                                //               child:Stack(
                                //                 children: [
                                //                   selectedColorItemIndex == index ?
                                //                   Container(
                                //                     margin: EdgeInsets.symmetric(horizontal: 10),
                                //                     height:50,
                                //                     width: 50,
                                //                     decoration: BoxDecoration(
                                //                       border: Border.all(color: kMainColor),
                                //                         borderRadius: BorderRadius.circular(100)
                                //                     ),
                                //                     child: Padding(
                                //                       padding: const EdgeInsets.all(8.0),
                                //                       child: Container(
                                //                         decoration: BoxDecoration(
                                //                             color: Color(int.parse('0xFF${product!.thecolor[index]}')),
                                //                             borderRadius: BorderRadius.circular(100)
                                //                           //more than 50% of width makes circle
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ):
                                //                   Container(
                                //                     height:50,
                                //                     width: 50,
                                //                     margin: EdgeInsets.symmetric(horizontal: 10),
                                //                     decoration: BoxDecoration(
                                //                         color: Color(int.parse('0xFF${product!.thecolor[index]}')),
                                //                         borderRadius: BorderRadius.circular(100)
                                //                       //more than 50% of width makes circle
                                //                     ),
                                //                   ),
                                //                 ],
                                //               ),
                                //             );
                                //           },
                                //         ),)
                                //     ],
                                //   ),
                                // ),
                                SizedBox(height: 15,),
                                Text(
                                  'description'.tr,
                                  style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(product!.info!,
                                  textAlign: TextAlign.justify,
                                  //overflow: TextOverflow.ellipsis,
                                  //maxLines: 1,
                                  style: GoogleFonts.aladin(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      height: 1.2,
                                      letterSpacing: 1.0,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(7),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: kMainColor, // Set border color
                                          width: 1.5),   // Set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0)), // Set rounded corner radius
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("with_tabby".tr,
                                              style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    //fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            SizedBox(width: 5,),
                                            Text(
                                              '${product!.discount! / 4}',
                                              style: GoogleFonts.cairo(
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              'price'.tr,
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("with_tabby_2".tr,
                                              style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    //fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            SizedBox(width: 5,),
                                            Image.asset(
                                                'assets/images/tabby.png',
                                              width: 50,
                                              height: 50,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                                SizedBox(height: 5,),
                                Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(7),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: kMainColor, // Set border color
                                          width: 1.5),   // Set border width
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(0)), // Set rounded corner radius
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("with_tamara".tr,
                                              style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    //fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            SizedBox(width: 5,),
                                            Text(
                                              '${(product!.discount! / 3).round()}',
                                              style: GoogleFonts.cairo(
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              'price'.tr,
                                              style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("with_tamara_2".tr,
                                              style: GoogleFonts.cairo(
                                                  textStyle: TextStyle(
                                                    fontSize: 16,
                                                    //fontWeight: FontWeight.bold
                                                  )
                                              ),),
                                            SizedBox(width: 5,),
                                            Image.asset(
                                              'assets/images/tamara.jpeg',
                                              width: 50,
                                              height: 50,
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                                // Expandable(
                                //   collapsed: Text(product!.info!,
                                //     textAlign: TextAlign.justify,
                                //     overflow: TextOverflow.ellipsis,
                                //     maxLines: 1,
                                //     style: GoogleFonts.aladin(
                                //       textStyle: TextStyle(
                                //         fontSize: 15,
                                //         height: 1.2,
                                //         letterSpacing: 1.0,
                                //         color: Colors.grey[600],
                                //       ),
                                //     ),
                                //   ),
                                //   expanded: Text(product!.info!,
                                //     style: GoogleFonts.aladin(
                                //       textStyle: TextStyle(
                                //         fontSize: 15,
                                //         height: 1.2,
                                //         letterSpacing: 1.0,
                                //         color: Colors.grey[600],
                                //       ),
                                //     ),),
                                // ),
                                // Builder(
                                //   builder: (BuildContext context) {
                                //     var controller = ExpandableController.of(context);
                                //     return Row(
                                //       mainAxisAlignment: MainAxisAlignment.end,
                                //       children: <Widget>[
                                //         TextButton(
                                //           child: Text(
                                //             controller!.expanded ? 'show_less'.tr : 'show_more'.tr,
                                //             style: TextStyle(
                                //               color: Colors.blue,
                                //             ),
                                //           ),
                                //           onPressed: () {
                                //             controller.toggle();
                                //           },
                                //         ),
                                //       ],
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
          persistentFooterButtons: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 8,
              // decoration: BoxDecoration(
              //   color: Colors.grey[200],
              //   borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(20),
              //       topRight: Radius.circular(20)),
              // ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Container(
                      height: 50,
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
                            onTap: subtract,
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          first_image.isEmpty?
                          Text(
                            _quantity.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ):
                          Text(
                            qu_index.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: add,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap:(){
                          if(img_id != 0){
                            CartItem cartItem=Provider.of<CartItem>(context,listen: false);
                            product!.quantity = qu_index;
                            product!.image = myimage;
                            product!.id = img_id.toString();
                            //product.size = size;
                            //product.color = color;
                            var productsInCart = cartItem.products;
                            for (var productInCart in productsInCart) {
                              if (productInCart.id == product!.id) {
                                //product!.image = myimage;
                                exist = true;
                              }
                            }
                            if (exist) {
                              print('with');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('item_exict'.tr,style: GoogleFonts.cairo(),),
                              ));
                              setState(() {
                                exist = false;
                              });
                            }
                            else {
                              // setState(() {
                              //   visibilityCount = true ;
                              //   box.write('myimage', myimage);
                              // });
                              //product!.image = myimage;
                              cartItem.addProductwithImage(product!,product!.quantity,product!.image!,int.parse(product!.id!));
                              setState(() {
                                // first_image = '';
                                // qu_index = 1;
                                // myimage = '';
                                // img_id = 1;
                                exist = false;
                              });
                              //cartItem.addProductwithImage(product!,product!.quantity,product!.myimage);
                              //   if(product!.id == product!.id){
                              //     cartItem.addProduct(product!,product!.quantity);
                              //   }else if(product!.id != product!.id){
                              //     product!.myimage = product!.image.toString();
                              //     cartItem.addProductwithImage(product!,product!.quantity,product!.myimage,product!.img_id);
                              // }
                              //cartItem.addProductwithImage(product!,product!.quantity,product!.image!);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('item_added'.tr,style: GoogleFonts.cairo(),),
                              ));
                              exist = false;
                              Get.to(CartScreen());
                            }
                          }
                          else{
                            CartItem cartItem=Provider.of<CartItem>(context,listen: false);
                            product!.quantity = _quantity;
                            //product!.myimage = myimage;
                            //product!.img_id = img_id;
                            //product.size = size;
                            //product.color = color;
                            var productsInCart = cartItem.products;
                            for (var productInCart in productsInCart) {
                              if (productInCart.id == product!.id) {
                                //product!.image = myimage;
                                exist = true;
                              }
                            }
                            if (exist) {
                              print('without');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('item_exict'.tr,style: GoogleFonts.cairo(),),
                              ));
                              setState(() {
                                exist = false;
                              });
                            }
                            else {
                              // setState(() {
                              //   visibilityCount = true ;
                              //   box.write('myimage', myimage);
                              // });
                              //product!.image = myimage;
                              cartItem.addProduct(product!,product!.quantity);
                              // setState(() {
                              //   first_image = '';
                              //   qu_index = 1;
                              //   myimage = '';
                              //   img_id = 1;
                              //   exist = false;
                              // });
                              //cartItem.addProductwithImage(product!,product!.quantity,product!.myimage);
                              //   if(product!.id == product!.id){
                              //     cartItem.addProduct(product!,product!.quantity);
                              //   }else if(product!.id != product!.id){
                              //     product!.myimage = product!.image.toString();
                              //     cartItem.addProductwithImage(product!,product!.quantity,product!.myimage,product!.img_id);
                              // }
                              //cartItem.addProductwithImage(product!,product!.quantity,product!.image!);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('item_added'.tr,style: GoogleFonts.cairo(),),
                              ));
                              exist = false;
                              Get.to(CartScreen());
                            }
                          }
                          exist = false;
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Center(
                            child: Text(
                                'btn_add'.tr,
                                style: GoogleFonts.cairo(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )
                                )
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: kMainColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }
  subtract() {
    if(first_image.isNotEmpty){
      if (qu_index > 1) {
        setState(() {
          qu_index--;
        });
      }else{
        if (_quantity > 1) {
          setState(() {
            _quantity--;
          });
        }
      }
    }

  }

  add() {
    setState(() {
      if(first_image.isNotEmpty){
        qu_index++;
      }else{
        _quantity++;
      }
    });
  }
}
