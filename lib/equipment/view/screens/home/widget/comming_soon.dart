import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/images.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("motorey Travel"),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(Images.commingSoon),
          SizedBox(
            height: 10,
          ),
          Text(
            "Coming Soon".tr,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          )
        ]),
      ),
    );
  }
}
