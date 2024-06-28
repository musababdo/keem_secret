
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:panorama_home/constants.dart';
import 'package:panorama_home/screens/category_product.dart';
import 'package:shimmer/shimmer.dart';

class Category extends StatefulWidget {

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  Future getCatigory() async{
    var url = Uri.parse('${api}categories');
    // final Map<String, String> headers = {
    //   'Authorization': 'Bearer $token',
    //   'lang': '$lang',
    //   'Accept': 'application/json',
    // };
    var response = await http.post(url);
    final jsonresponse = json.decode(response.body);
    // print('*********************');
    // print(jsonresponse);
    // print('*********************');
    return jsonresponse;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCatigory();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: MediaQuery.of(context).size.height / 5.5,
      child:FutureBuilder(
        future: getCatigory(),
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
                  return GestureDetector(
                    onTap:(){
                      box.write('c_id', snapshot.data[index]["id"]);
                      box.write('c_name', snapshot.data[index]['name']);
                      Get.to(CategoryProduct());
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 11,
                            //padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              child: FadeInImage.assetNetwork(
                                image: '${api_image}media/categories/'+snapshot.data[index]['image'],
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
                        Text(
                          snapshot.data[index]['name'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                          textStyle: TextStyle(
                            fontSize: 11,
                          ),
                        ),),
                      ],
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 5,
                                height: MediaQuery.of(context).size.height / 9,
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
                            Text(
                              "".tr,style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 16,
                              ),
                            ),),
                          ],
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
    );
  }
}
