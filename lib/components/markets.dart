
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Markets extends StatefulWidget {

  @override
  State<Markets> createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "markets".tr,style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                    fontSize: 18,
                      fontWeight: FontWeight.w600
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
          //const SizedBox(height: 20),
          Row(
            children: [
              for(int i=0;i<4;i++)
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
            ],
          ),
        ],
      ),
    );
  }
}
