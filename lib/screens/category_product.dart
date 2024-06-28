
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:http/http.dart' as http;
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/provider/cartItem.dart';
import 'package:panorama_home/screens/details.dart';
import 'package:panorama_home/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:super_banners/super_banners.dart';

class CategoryProduct extends StatefulWidget {
  const CategoryProduct({super.key});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {

  String? name,lang;
  int? id;
  int _quantity = 1;
  List<Product> myproducts = [];

  Future getProducts() async{
    var url = Uri.parse('${api}products_by_category_id/$id');
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'lang': '$lang',
    };
    var response = await http.get(url,headers: headers);
    final jsonresponse = json.decode(response.body);
    // print('*********************');
    // print(jsonresponse);
    // print('*********************');
    return jsonresponse['products'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = box.read('lang');
    name = box.read('c_name');
    id   = box.read('c_id');
    print(id);
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: kMainColor,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainColor,
          //automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(name!,
            style: GoogleFonts.cairo(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                //fontWeight: FontWeight.bold
              ),
            ),),
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getProducts(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            try {
              if(snapshot.data.length > 0 ){
                return GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .8,
                    ),
                    shrinkWrap: true,
                    //physics: ScrollPhysics(),
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      //List list = snapshot.data;
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
                      // print('*********************');
                      // print(snapshot.data.length);
                      // print('*********************');
                      return GestureDetector(
                        onTap:(){
                          //box.write('c_id', snapshot.data[index]["id"]);
                          //box.write('c_name', snapshot.data[index]["title"]);
                          //Get.to(CatigoryProduct());
                          box.write('main_id', snapshot.data[index]['main_product_id']);
                          Navigator.pushNamed(context, Details.id,arguments: myproducts[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0.03),
                          child: Stack(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                elevation: 2,
                                child:Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     border: Border.all(
                                  //          color: kMainColor,
                                  //         width:.1)
                                  // ),
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.height / 6.3,
                                          //padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                topLeft: Radius.circular(12)),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                topLeft: Radius.circular(12)),
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
                                      //Padding(padding: const EdgeInsets.only(top:3.5)),
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
                    });
              }else{
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
                              'assets/images/no_login.jpg',
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 4,),
                            SizedBox(height: 20,),
                            Text('home_no_result'.tr,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            GestureDetector(
                              onTap:(){
                                Get.to(Home());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                            ),
                          ],
                        )
                    ),
                  ),
                );
              }
            }catch(e){
              return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .8,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    //List list = snapshot.data;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
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
                      ),
                    );
                  }
              );
            }
          },
        ),
      ),
    );
  }
}
