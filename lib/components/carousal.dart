import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:panorama_home/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class Carousal extends StatefulWidget {
  const Carousal({super.key});

  @override
  State<Carousal> createState() => _CarousalState();
}

class _CarousalState extends State<Carousal> {
  int _mycurrentIndex = 0;
  List<Widget> _mybuildIndicators() {
    return List<Widget>.generate(images.length, (index) {
      return Container(
        width: 8,
        height: 8,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _mycurrentIndex == index ? kMainColor : Colors.grey,
        ),
      );
    });
  }
  var images = [];
  String? jsonString;
  Future getBanners() async{
    var url = Uri.parse('${api}banners');
    // final Map<String, String> headers = {
    //   'Authorization': 'Bearer $token',
    //   'lang': '$lang',
    //   'Accept': 'application/json',
    // };
    var response = await http.post(url);
    final jsonresponse = json.decode(response.body);
    //List<dynamic> myArray = jsonresponse['banners'].toList();
    //List<Map<String, dynamic>> jsonList = jsonresponse['data']['banners'].map((data) => data.toJson()).toList();
    //images = myArray;
    //String arrayToString = convertArrayToString(jsonresponse);
    //images= jsonresponse.map((item) => item.toString()).toList();
    //List<String> stringList = jsonresponse['banners'].map((dynamic item) => item.toString()).toList();
    //jsonString = jsonEncode(images);
    //images = arrayToString;

    for(int i=0;i<=1000000;i++){
      images.add(jsonresponse['data'][i]['image']);
    }

    // print('*********************');
    // print(images);
    // print('*********************');
    return jsonresponse;
  }

  String convertArrayToString(List<dynamic> array) {
    StringBuffer stringBuffer = StringBuffer();

    for (List<dynamic> innerList in array) {
      // Convert inner list to string and append to the buffer
      stringBuffer.write("${innerList.join(", ")}\n");
    }

    // Convert the StringBuffer to a regular String
    String result = stringBuffer.toString();
    images.add(result);
    images.join(',');

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      //color: Colors.red,
      child: FutureBuilder(
        // Simulate loading data. Replace this with your actual data loading logic.
        future: Future.delayed(Duration(microseconds: 2), () => true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for data, show shimmer effect
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CarouselSlider.builder(
                itemCount: 10, // Replace with your actual item count
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 3,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    color: Colors.grey, // Placeholder color
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            // Handle errors
            return Container();
          } else {
            // Data has been loaded, show actual carousel
            return CarouselSlider.builder(
              itemCount: images.length, // Replace with your actual item count
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 3,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                // onPageChanged: (index, reason) {
                //   setState(() {
                //     _mycurrentIndex = index;
                //   });
                // },
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
              ),
              itemBuilder: (context, index, realIndex) {
                // Replace this with your actual carousel item widget
                return Stack(
                  children: [
                    images.isNotEmpty?
                    FadeInImage.assetNetwork(
                      image: '${api_image}media/banners/'+images[index],
                      placeholder: 'assets/images/place.png',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/place.png',
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 4,
                            fit: BoxFit.cover);
                      },
                      fit: BoxFit.cover,
                    ):
                    Image.asset('assets/images/place.png',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover),

                    // Column(
                    //   children: [
                    //     SizedBox(height:MediaQuery.of(context).size.height * .28,),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: _mybuildIndicators(),
                    //     ),
                    //   ],
                    // )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
