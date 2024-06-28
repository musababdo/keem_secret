
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:panorama_home/constants.dart';
import 'package:http/http.dart' as http;
import 'package:panorama_home/screens/category_product.dart';
import 'package:shimmer/shimmer.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('category'.tr,
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                //fontWeight: FontWeight.bold
            ),
          ),),
      ),
      body: FutureBuilder(
        future: getCatigory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          try {
            if(snapshot.data.length > 0 ){
              return snapshot.hasData ?
              ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    //List list = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: screenHeight * .18,
                        child: GestureDetector(
                          onTap:(){
                            box.write('c_id', snapshot.data[index]["id"]);
                            box.write('c_name', snapshot.data[index]['name']);
                            Get.to(CategoryProduct());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            elevation: 8,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 4.5,
                                padding: EdgeInsets.all(20),
                                //margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${api_image}media/categories/'+snapshot.data[index]['image']),
                                    fit: BoxFit.cover,
                                    opacity: 0.7,
                                  ),
                                ),
                                child:Center(
                                  child: Text(
                                    snapshot.data[index]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        )
                                    ),
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                    );
                  })
                  : new Center(
                child: new CircularProgressIndicator(),
              );
            }else{
              return Container(
                height: screenHeight -
                    (screenHeight * .08) -
                    appBarHeight -
                    statusBarHeight,
                child: Center(
                  child: Text('لايوجد',
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              );
            }
          }catch(e){
            return ListView.builder(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: screenHeight * .18,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            elevation: 8,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 4.5,
                                padding: EdgeInsets.all(20),
                                //margin: EdgeInsets.only(left: 15),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/ad.webp'),
                                    fit: BoxFit.cover,
                                    opacity: 0.7,
                                  ),
                                ),
                                child:Center(
                                  child: Text(
                                    '',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ),
                                )
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
