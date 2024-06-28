
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/details.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_banners/super_banners.dart';
import 'package:http/http.dart' as http;

class Newest extends StatefulWidget {

  @override
  State<Newest> createState() => _NewestState();
}

class _NewestState extends State<Newest> {
  String? lang;
  int _quantity = 1;
  List<Product> myproducts = [];
  Product? product;

  var images = [];
  List<Map<String, dynamic>> keyValueList = [];
  Future getNewest() async{
    var url = Uri.parse('${api}products');
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'lang': '$lang',
    };
    var response = await http.post(url,headers: headers);
    final jsonresponse = json.decode(response.body);
    // setState(() {
    //   for(int i=0;i<=1000000;i++){
    //     //images.add(jsonresponse['products'][i]['image']);
    //     Map<String, dynamic> keyValue = {
    //       'code': jsonresponse['products'][i]['code'],
    //       'image': jsonresponse['products'][i]['image'],
    //     };
    //     keyValueList.add(keyValue);
    //     print('*********************');
    //     print(keyValueList);
    //     print('*********************');
    //   }
    // });
    return jsonresponse['products'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = box.read('lang');
    getNewest();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .5,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Padding(
              padding: const EdgeInsets.only(top: 13,bottom: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "newest".tr,style: GoogleFonts.cairo(
                    textStyle: TextStyle(
                      fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),),
                  // GestureDetector(
                  //   onTap:(){
                  //     //Get.to(Catigory());
                  //   },
                  //   child: Text(
                  //     "more".tr,
                  //     style: GoogleFonts.cairo(),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          //const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: getNewest(),
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
                        snapshot.data[index]['discount']==null?
                        myproducts.add(Product(
                          snapshot.data[index]['id'].toString(),
                          snapshot.data[index]['name'],
                          '${api_image}media/products/'+snapshot.data[index]['image'],
                          double.parse(snapshot.data[index]['price'].toString()),
                          0,
                          snapshot.data[index]['description'],
                          _quantity,
                          '',
                          0
                        )):
                        myproducts.add(Product(
                          snapshot.data[index]['id'].toString(),
                          snapshot.data[index]['name'],
                          '${api_image}media/products/'+snapshot.data[index]['image'],
                          double.parse(snapshot.data[index]['price'].toString()),
                          double.parse(snapshot.data[index]['total_price'].toString()),
                          snapshot.data[index]['description'],
                          _quantity,
                          '',
                          0
                        ));
                        // for(int i=0;i<=snapshot.data.length;i++){
                        //   images.add(snapshot.data[i]['image']);
                        //   // Map<String, dynamic> keyValue = {
                        //   //   'code': snapshot.data[i]['code'],
                        //   //   'image': snapshot.data[i]['image'],
                        //   // };
                        //   // keyValueList.add(keyValue);
                        //   print('*********************');
                        //   print(images);
                        //   print('*********************');
                        // }
                        return GestureDetector(
                          onTap:(){
                            //box.write('c_id', snapshot.data[index]["id"]);
                            //box.write('c_name', snapshot.data[index]["title"]);
                            //Get.to(CatigoryProduct());
                            box.write('main_id', snapshot.data[index]['main_product_id']);

                            // box.write('index_id', snapshot.data[index]['id'].toString());
                            // box.write('index_name', snapshot.data[index]['name']);
                            // box.write('index_image', '${api_image}media/products/'+snapshot.data[index]['image']);
                            // box.write('index_discount', snapshot.data[index]['discount'].toString());
                            // box.write('index_price', snapshot.data[index]['price'].toString());
                            // box.write('index_total_price', snapshot.data[index]['total_price'].toString());
                            // box.write('index_description', snapshot.data[index]['description']);
                            // box.write('index_quantity', _quantity.toString());

                            Navigator.pushNamed(context, Details.id,arguments: myproducts[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.03),
                            child: Stack(
                              children: [
                                Container(
                                 height: MediaQuery.of(context).size.height * .4,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    elevation: 2,
                                    child:Container(
                                      width: MediaQuery.of(context).size.width / 2.4,
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //     border: Border.all(
                                      //          color: kMainColor,
                                      //         width:.1)
                                      // ),
                                      child: Column(
                                        //mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height / 5.5,
                                              //padding: EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(8),
                                                    topLeft: Radius.circular(8)),
                                                child: FadeInImage.assetNetwork(
                                                  image: '${api_image}media/products/'+snapshot.data[index]['image'],
                                                  placeholder: 'assets/images/place.png',
                                                  height: MediaQuery.of(context).size.height,
                                                  width: MediaQuery.of(context).size.width,
                                                  imageErrorBuilder: (context, error, stackTrace) {
                                                    return Image.asset('assets/images/place.png',
                                                        //width: MediaQuery.of(context).size.width / 3,
                                                        //height: MediaQuery.of(context).size.height / 4,
                                                        fit: BoxFit.cover);
                                                  },
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          //SizedBox(height: MediaQuery.of(context).size.height / 30,),
                                          Column(
                                            //mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                            children: [
                                              SizedBox(height: 10,),
                                              Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 8,left: 8,bottom: 10),
                                                  child: Text(
                                                    snapshot.data[index]['name'],
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: GoogleFonts.cairo(
                                                      textStyle: TextStyle(
                                                        fontSize: 10.5,
                                                      ),
                                                    ),),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Padding(
                                                padding: EdgeInsets.only(right: 5,left: 5,bottom: 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        snapshot.data[index]['discount']==null || double.parse(snapshot.data[index]['discount'].toString()) > double.parse(snapshot.data[index]['discount'].toString()) || double.parse(snapshot.data[index]['discount'].toString()) == double.parse(snapshot.data[index]['price'].toString())?
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[index]['price']}',
                                                              style: GoogleFonts.cairo(
                                                                textStyle: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Text(
                                                              'price'.tr,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.cairo(
                                                                textStyle: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ):
                                                        Column(
                                                          //mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '(OFF ${snapshot.data[index]['percent_disc']}%)',
                                                              style: GoogleFonts.cairo(
                                                                textStyle: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors.green
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 3,),
                                                            Text(
                                                              '${snapshot.data[index]['price']}',
                                                              style: GoogleFonts.cairo(
                                                                textStyle: TextStyle(
                                                                    fontSize: 11,
                                                                    color: kMainColor,
                                                                    decoration: TextDecoration.lineThrough
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 10,),
                                                        snapshot.data[index]['discount']==null || double.parse(snapshot.data[index]['discount'].toString()) > double.parse(snapshot.data[index]['discount'].toString()) || double.parse(snapshot.data[index]['discount'].toString()) == double.parse(snapshot.data[index]['price'].toString())?
                                                        Container():
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[index]['total_price']}',
                                                              style: GoogleFonts.cairo(
                                                                textStyle: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors.black
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            Text(
                                                              'price'.tr,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: GoogleFonts.cairo(
                                                                textStyle: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors.black
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 12),
                                                      child: GestureDetector(
                                                        onTap:(){
                                                          CartItem cartItem=Provider.of<CartItem>(context,listen: false);
                                                          myproducts[index].quantity = _quantity;
                                                          //product.size = size;
                                                          //product.color = color;
                                                          bool exist = false;
                                                          var productsInCart = cartItem.products;
                                                          for (var productInCart in productsInCart) {
                                                            if (productInCart.id == snapshot.data[index]['id'].toString()) {
                                                              exist = true;
                                                            }
                                                          }
                                                          if (exist) {
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              backgroundColor: Colors.green,
                                                              content: Text('item_exict'.tr,style: GoogleFonts.cairo(),),
                                                            ));
                                                          } else {
                                                            cartItem.addProduct(myproducts[index],myproducts[index].quantity);
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                              backgroundColor: Colors.green,
                                                              content: Text('item_added'.tr,style: GoogleFonts.cairo(),),
                                                            ));
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: MediaQuery.of(context).size.width / 6,
                                                          child: Center(
                                                            child: Text(
                                                                'btn_add'.tr,
                                                                style: GoogleFonts.cairo(
                                                                    textStyle: TextStyle(
                                                                      fontSize: 9.5,
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
                                                    ),
                                                  ],
                                                ),
                                              )
                                              //SizedBox(height: MediaQuery.of(context).size.height / 35,),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    child: lang=='ar'?
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CornerBanner(
                                        bannerPosition: CornerBannerPosition.topRight,
                                        bannerColor: kMainColor,
                                        child: Text(
                                          //"تخفيض %${getDiscount(double.parse(snapshot.data[index]['price'].toString()), double.parse(snapshot.data[index]['discount'].toString()))}",
                                            'new'.tr,
                                            style: GoogleFonts.cairo(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                )
                                            )),
                                      ),
                                    ):
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CornerBanner(
                                        bannerPosition: CornerBannerPosition.topLeft,
                                        bannerColor: kMainColor,
                                        child:Text(
                                          //"${getDiscount(double.parse(snapshot.data[index]['price'].toString()), double.parse(snapshot.data[index]['discount'].toString()))}% OFF",
                                          'new'.tr,
                                          style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                              )
                                          ),),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      : Center(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          //List list = snapshot.data;
                          return Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey,
                              highlightColor: Colors.white,
                              child: Container(
                                width: 160,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    // city1.jpg
                                    image: AssetImage(
                                        "assets/images/img1.jpg"),
                                    fit: BoxFit.cover,
                                    opacity: 0.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "",
                                        style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  );
                }catch(e){
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        //List list = snapshot.data;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey,
                            highlightColor: Colors.white,
                            child: Container(
                              width: 160,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  // city1.jpg
                                  image: AssetImage(
                                      "assets/images/img1.jpg"),
                                  fit: BoxFit.cover,
                                  opacity: 0.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "",
                                      style: GoogleFonts.cairo(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
