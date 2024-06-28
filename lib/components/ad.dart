
import 'package:flutter/material.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 8),
      child: Container(
        //width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.height / 4,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.all(Radius.circular(12)),
          image: DecorationImage(
            image: AssetImage(
                'assets/images/photo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
