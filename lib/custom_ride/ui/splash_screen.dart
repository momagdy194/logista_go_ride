import 'package:customer/custom_ride/controller/splash_controller.dart';
import 'package:customer/custom_ride/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: Center(child: Image.asset("assets/app_logo.png",width: 200,)),
          );
        });
  }
}
