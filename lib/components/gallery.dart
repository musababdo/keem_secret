
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/models/product.dart';
import 'package:panorama_home/screens/details.dart';
import 'package:shimmer/shimmer.dart';

class Gallery extends StatefulWidget {

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  int _quantity = 1;
  List<Product> myproducts = [];

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
    getGallery();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: FutureBuilder(
        future: getGallery(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          try {
            if(snapshot.data.length > 0 ){
              return snapshot.hasData ?
              GridView.builder(
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .8,
                  ),
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    //List list = snapshot.data;
                    // print('/////////////////////');
                    // print(snapshot.data[0]['info']['name']);
                    // print('/////////////////////');
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
                      double.parse(snapshot.data[index]['discount'].toString()),
                      snapshot.data[index]['description'],
                      _quantity,
                      '',
                      0
                    ));
                    return GestureDetector(
                      onTap:(){
                        // print('/////////////////////');
                        // print(snapshot.data[index]['images']);
                        // print('/////////////////////');
                        //box.write('imgs', snapshot.data[index]['images']);
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => details(list: list,index: index,),),);
                        //Navigator.pushNamed(context, Details.id,arguments: myproducts[index]);
                        Navigator.pushNamed(context, Details.id,arguments: myproducts[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8,left: 8,top: 10,bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 3.5,
                          //padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            child: FadeInImage.assetNetwork(
                              image: '${api_image}media/products/'+snapshot.data[index]['image'],
                              placeholder: 'assets/images/myloader.gif',
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/myloader.gif',
                                    //width: MediaQuery.of(context).size.width / 3,
                                    //height: MediaQuery.of(context).size.height / 4,
                                    fit: BoxFit.cover);
                              },
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  : Center(
                child: Image.asset('assets/images/myloader.gif'),
              );
            }else{
              return Container(
                height: screenHeight -
                    (screenHeight * .08) -
                    appBarHeight -
                    statusBarHeight,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/sad.gif'),
                        Text('home_no_result'.tr,
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ],
                    )
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
                        padding: const EdgeInsets.only(right: 8,left: 8,top: 10,bottom: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 3.5,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/visionshop.jpg'),
                              fit: BoxFit.cover,
                            ),
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
    );
  }
}
