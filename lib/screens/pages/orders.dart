
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:panorama_home/constants.dart';
import 'package:http/http.dart' as http;
import 'package:panorama_home/screens/home.dart';
import 'package:panorama_home/screens/login.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  final formatter = new NumberFormat("###,###");
  String? lang,token;
  int? id;
  Future getOrders() async{
    var url = Uri.parse('${api}orders');
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var response = await http.get(url,headers: headers);
    final jsonresponse = json.decode(response.body);
    // print('*********************');
    // print(jsonresponse['orders']);
    // print('*********************');
    return jsonresponse['orders'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = box.read('lang');
    id = box.read('u_id');
    token = box.read('token');
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
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
        title: Text('home_order'.tr,
          style: GoogleFonts.cairo(
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                //fontWeight: FontWeight.bold
            ),
          ),),
      ),
      backgroundColor: Colors.white,
      body:token !=null?
      FutureBuilder(
        future:getOrders(),
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
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          elevation: 8,
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              //mainAxisAlignment:MainAxisAlignment.center ,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'total'.tr,
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          color:kMainColor,
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          formatter.format(snapshot.data[index]["total_amount"]),
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          'price'.tr,
                                          style: GoogleFonts.cairo(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
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
                                    Text(
                                      'step_three'.tr,
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          color:kMainColor,
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data[index]["payment_method"],
                                      style: GoogleFonts.cairo(
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          color:Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
                            'assets/images/empty_order.webp',
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 4,),
                          SizedBox(height: 10,),
                          Text('order_empty'.tr,
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 20,
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
                                      "login_btn".tr,
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
            return Center(
              child: Image.asset('assets/images/myloader.gif'),
            );
          }
        },
      ):
      Container(
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
                  Text('login_first'.tr,
                    style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap:(){
                      Get.to(Login());
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
                              "login_btn".tr,
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
      ),
    );
  }
}
